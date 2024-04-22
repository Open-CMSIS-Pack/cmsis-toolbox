import os
import subprocess
from robot.api import logger
from robot.utils import asserts

def compare_elf_information(input_file, cbuildgen_out_dir, cbuild2cmake_out_dir):
    logger.debug('Input file: %s' % input_file)
    logger.debug('Cbuildgen out dir: %s' % cbuildgen_out_dir)
    logger.debug('Cbuild2cmake out dir: %s' % cbuild2cmake_out_dir)
    result = CompareELF(input_file, cbuildgen_out_dir, cbuild2cmake_out_dir).compare_elf_files()
    return result
    

class Context:
    def __init__(self, strContext: str):
        self.project = ""
        self.build = ""
        self.target = ""
        self.parse_context(strContext)

    def parse_context(self, strContext: str):
        parts = strContext.split('.')
        if len(parts) == 2:
            self.project = parts[0]
            temp_parts = parts[1].split('+')
            if len(temp_parts) == 2:
                self.build = temp_parts[0]
                self.target = temp_parts[1]
            else:
                self.target = parts[1]
        else:
            print("Invalid context format. Expected format: 'project.build+target'")
        
class Utils:
    @staticmethod
    def run_command(exe_path, args):
        try:
            command = exe_path + ' ' + ' '.join(args)
            logger.info(f"Running Command: {' '.join(command)}")
            processOut = subprocess.run(command, check=True, shell=True, universal_newlines=True, capture_output=True, timeout=300)
            return True, processOut.stdout
        except subprocess.CalledProcessError as e:
            logger.error(f"Error executing command: {e}")
            return False, e.stderr
        except subprocess.TimeoutExpired as e:
            logger.error(f"Command execution timed out: {e}")
            return False, "Command execution timed out"
        except Exception as e:
            logger.error(f"An unexpected error occurred: {e}")
            return False, "An unexpected error occurred"

class CompareELF:
    def __init__(self, input_file, cbuildgen_out_dir, cbuild2cmake_out_dir):
        self.input_file = input_file
        self.cbuildgen_out_dir = cbuildgen_out_dir
        self.cbuild2cmake_out_dir = cbuild2cmake_out_dir

    def compare_elf_files(self):
        context_list = self.get_contexts()
        if len(context_list) == 0:
            return False
    
        success = True
        for context in context_list:
            logger.info('Processing context: %s.%s+%s' % (context.project, context.build, context.target))
            path = self.get_elf_file_path(self.cbuildgen_out_dir, context)
            logger.debug('Path: %s' % path)
            if path != '':
                cbuildgen_elf_file = os.path.join(self.cbuildgen_out_dir, path)
                cbuild2cmake_elf_file = os.path.join(self.cbuild2cmake_out_dir, path)
                res1, stdout1 = self.get_elf_info(cbuildgen_elf_file)
                res2, stdout2 = self.get_elf_info(cbuild2cmake_elf_file)
                logger.info('Object Info %s' % stdout1)
                logger.info('Object Info %s' % stdout2)
                success &= (res1 == res2)
        return success
      
    def get_elf_file_path(self, basePath, context: Context):
        file_extns = [".axf", ".elf"]
        for extn in file_extns:
            filePath = os.path.join(basePath, context.project, context.target, context.build, context.project+extn)
            if os.path.exists(filePath):
                elf_file_path = '/'.join([context.project, context.target, context.build, context.project+extn])
                return elf_file_path
        return ''

    def get_elf_info(self, elf_file):
        args = [elf_file, "-z"]
        return Utils.run_command("fromelf", args)
    
    def get_contexts(self):
        args = ["list", "contexts", self.input_file]
        success, output = Utils.run_command("cbuild", args)
        contextList = []
        logger.debug('cbuild list contexts %s' % output)
        if success == True:
            strContext = output.splitlines()
            for context in strContext:
                contextList.append(Context(context))
        return contextList
