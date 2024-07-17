# Robot Framework Report

## Test Environment

|Name|Version|
|:---|:------|
|cbuild|2.4.0-43-gd715d2f|
|cpackget|2.1.3-1-g0aaeca9|
|csolution|2.4.0+p63-g2fdb3c85|
|cbuild2cmake|0.9.1-26-g1120292|
|cbuildgen|2.4.0+p62-g2fdb3c85|

## Summary

|:white_check_mark: Passed|:x: Failed|:fast_forward: Skipped|Total|
|:----:|:----:|:-----:|:---:|
|39|15|0|53|

## Passed Tests

|Tag|Test|:clock1030: Duration|Suite|
|:---:|:---:|:---:|:---:|
|windows-amd64|Validate build-c Example|6.01 s|Local Example Tests|
|windows-amd64|Validate build-cpp Example|9.21 s|Local Example Tests|
|windows-amd64|Validate linker-pre-processing Example|6.39 s|Local Example Tests|
|windows-amd64|Validate pre-include Example|6.10 s|Local Example Tests|
|windows-amd64|Validate whitespace Example|6.04 s|Local Example Tests|
|windows-amd64|Validate trustzone Example|48.31 s|Local Example Tests|
|windows-amd64|Hello_B-U585I-IOT02A|44.34 s|Remote Example Tests|
|windows-amd64|Hello_FRDM-K32L3A6|27.11 s|Remote Example Tests|
|windows-amd64|Hello_IMXRT1050-EVKB|33.85 s|Remote Example Tests|
|windows-amd64|Hello_LPCXpresso55S69|29.09 s|Remote Example Tests|
|windows-amd64|Blinky_FRDM-K32L3A6|24.95 s|Remote Example Tests|
|windows-amd64|keil-studio-get-started|7.20 s|Remote Example Tests|
|windows-amd64|Hello_AVH|72.43 s|Remote Example Tests|
|linux-amd64|Validate build-c Example|1.59 s|Local Example Tests|
|linux-amd64|Validate build-cpp Example|2.45 s|Local Example Tests|
|linux-amd64|Validate linker-pre-processing Example|1.62 s|Local Example Tests|
|linux-amd64|Validate pre-include Example|1.69 s|Local Example Tests|
|linux-amd64|Validate whitespace Example|1.61 s|Local Example Tests|
|linux-amd64|Validate trustzone Example|7.59 s|Local Example Tests|
|linux-amd64|Hello_B-U585I-IOT02A|19.91 s|Remote Example Tests|
|linux-amd64|Hello_FRDM-K32L3A6|8.79 s|Remote Example Tests|
|linux-amd64|Hello_IMXRT1050-EVKB|11.89 s|Remote Example Tests|
|linux-amd64|Hello_LPCXpresso55S69|15.33 s|Remote Example Tests|
|linux-amd64|Blinky_FRDM-K32L3A6|9.20 s|Remote Example Tests|
|linux-amd64|keil-studio-get-started|3.63 s|Remote Example Tests|
|linux-amd64|Hello_AVH|28.00 s|Remote Example Tests|
|darwin-amd64|Validate build-c Example|4.44 s|Local Example Tests|
|darwin-amd64|Validate build-cpp Example|6.57 s|Local Example Tests|
|darwin-amd64|Validate linker-pre-processing Example|4.56 s|Local Example Tests|
|darwin-amd64|Validate pre-include Example|4.72 s|Local Example Tests|
|darwin-amd64|Validate whitespace Example|4.82 s|Local Example Tests|
|darwin-amd64|Validate trustzone Example|19.98 s|Local Example Tests|
|darwin-amd64|Hello_B-U585I-IOT02A|32.40 s|Remote Example Tests|
|darwin-amd64|Hello_FRDM-K32L3A6|14.36 s|Remote Example Tests|
|darwin-amd64|Hello_IMXRT1050-EVKB|15.43 s|Remote Example Tests|
|darwin-amd64|Hello_LPCXpresso55S69|15.10 s|Remote Example Tests|
|darwin-amd64|Blinky_FRDM-K32L3A6|13.49 s|Remote Example Tests|
|darwin-amd64|keil-studio-get-started|5.79 s|Remote Example Tests|
|darwin-amd64|Hello_AVH|47.37 s|Remote Example Tests|

## Failed Tests

|Tag|Test|Message|:clock1030: Duration|Suite|
|:---:|:---:|:---:|:---:|:---:|
|windows-amd64|Validate build-asm Example|Unexpected status returned by cbuildgen execution: 1 != 0|10.03 s|Local Example Tests|
|windows-amd64|Validate include-define Example|Unexpected status returned by cbuild2cmake execution: 1 != 0|5.12 s|Local Example Tests|
|windows-amd64|Validate language-scope Example|Unexpected status returned by cbuildgen execution: 1 != 0|3.51 s|Local Example Tests|
|windows-amd64|Blinky_NUCLEO-G0B1RE|Unexpected status returned by cbuild2cmake execution: 1 != 0|22.25 s|Remote Example Tests|
|windows-amd64|Blinky_NUCLEO-F756ZG|Unexpected status returned by cbuild2cmake execution: 1 != 0|27.58 s|Remote Example Tests|
|linux-amd64|Validate build-asm Example|Unexpected status returned by cbuildgen execution: 1 != 0|3.25 s|Local Example Tests|
|linux-amd64|Validate include-define Example|Unexpected status returned by cbuild2cmake execution: 1 != 0|1.42 s|Local Example Tests|
|linux-amd64|Validate language-scope Example|Unexpected status returned by cbuildgen execution: 1 != 0|1.00 s|Local Example Tests|
|linux-amd64|Blinky_NUCLEO-G0B1RE|Unexpected status returned by cbuild2cmake execution: 1 != 0|10.52 s|Remote Example Tests|
|linux-amd64|Blinky_NUCLEO-F756ZG|Unexpected status returned by cbuild2cmake execution: 1 != 0|11.91 s|Remote Example Tests|
|darwin-amd64|Validate build-asm Example|Unexpected status returned by cbuildgen execution: 1 != 0|8.99 s|Local Example Tests|
|darwin-amd64|Validate include-define Example|Unexpected status returned by cbuild2cmake execution: 1 != 0|3.58 s|Local Example Tests|
|darwin-amd64|Validate language-scope Example|Unexpected status returned by cbuildgen execution: 1 != 0|2.35 s|Local Example Tests|
|darwin-amd64|Blinky_NUCLEO-G0B1RE|Unexpected status returned by cbuild2cmake execution: 1 != 0|14.92 s|Remote Example Tests|
|darwin-amd64|Blinky_NUCLEO-F756ZG|Unexpected status returned by cbuild2cmake execution: 1 != 0|21.39 s|Remote Example Tests|
