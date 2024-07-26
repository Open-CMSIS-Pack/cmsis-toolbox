# Robot Framework Report

## Summary

|:white_check_mark: Passed|:x: Failed|:fast_forward: Skipped|Total|
|:----:|:----:|:-----:|:---:|
|39|30|0|69|

## Passed Tests

|Tag|Test|:clock1030: Duration|Suite|
|:---:|:---:|:---:|:---:|
|windows-amd64|Validate build-c Example|6.16 s|Local Example Tests|
|windows-amd64|Validate build-cpp Example|9.34 s|Local Example Tests|
|windows-amd64|Validate linker-pre-processing Example|6.21 s|Local Example Tests|
|windows-amd64|Validate pre-include Example|6.53 s|Local Example Tests|
|windows-amd64|Validate whitespace Example|6.19 s|Local Example Tests|
|windows-amd64|Validate trustzone Example|43.75 s|Local Example Tests|
|windows-amd64|Hello_B-U585I-IOT02A|44.89 s|Remote Example Tests|
|windows-amd64|Hello_FRDM-K32L3A6|26.63 s|Remote Example Tests|
|windows-amd64|Hello_IMXRT1050-EVKB|40.38 s|Remote Example Tests|
|windows-amd64|Hello_LPCXpresso55S69|34.32 s|Remote Example Tests|
|windows-amd64|Blinky_FRDM-K32L3A6|31.87 s|Remote Example Tests|
|windows-amd64|keil-studio-get-started|7.74 s|Remote Example Tests|
|windows-amd64|Hello_AVH|66.01 s|Remote Example Tests|
|linux-amd64|Validate build-c Example|1.56 s|Local Example Tests|
|linux-amd64|Validate build-cpp Example|2.36 s|Local Example Tests|
|linux-amd64|Validate linker-pre-processing Example|1.58 s|Local Example Tests|
|linux-amd64|Validate pre-include Example|1.67 s|Local Example Tests|
|linux-amd64|Validate whitespace Example|1.56 s|Local Example Tests|
|linux-amd64|Validate trustzone Example|7.31 s|Local Example Tests|
|linux-amd64|Hello_B-U585I-IOT02A|18.62 s|Remote Example Tests|
|linux-amd64|Hello_FRDM-K32L3A6|7.96 s|Remote Example Tests|
|linux-amd64|Hello_IMXRT1050-EVKB|10.29 s|Remote Example Tests|
|linux-amd64|Hello_LPCXpresso55S69|9.72 s|Remote Example Tests|
|linux-amd64|Blinky_FRDM-K32L3A6|9.19 s|Remote Example Tests|
|linux-amd64|keil-studio-get-started|3.48 s|Remote Example Tests|
|linux-amd64|Hello_AVH|21.13 s|Remote Example Tests|
|darwin-amd64|Validate build-c Example|6.21 s|Local Example Tests|
|darwin-amd64|Validate build-cpp Example|7.63 s|Local Example Tests|
|darwin-amd64|Validate linker-pre-processing Example|5.42 s|Local Example Tests|
|darwin-amd64|Validate pre-include Example|5.73 s|Local Example Tests|
|darwin-amd64|Validate whitespace Example|6.03 s|Local Example Tests|
|darwin-amd64|Validate trustzone Example|25.30 s|Local Example Tests|
|darwin-amd64|Hello_B-U585I-IOT02A|37.63 s|Remote Example Tests|
|darwin-amd64|Hello_FRDM-K32L3A6|16.78 s|Remote Example Tests|
|darwin-amd64|Hello_IMXRT1050-EVKB|17.91 s|Remote Example Tests|
|darwin-amd64|Hello_LPCXpresso55S69|16.27 s|Remote Example Tests|
|darwin-amd64|Blinky_FRDM-K32L3A6|19.12 s|Remote Example Tests|
|darwin-amd64|keil-studio-get-started|11.36 s|Remote Example Tests|
|darwin-amd64|Hello_AVH|57.27 s|Remote Example Tests|

## Failed Tests

|Tag|Test|Message|:clock1030: Duration|Suite|
|:---:|:---:|:---:|:---:|:---:|
|windows-amd64|Validate build-asm Example|build status doesn't match: PASS != FAIL|20.27 s|Local Example Tests|
|windows-amd64|Validate include-define Example|build status doesn't match: FAIL != PASS|5.27 s|Local Example Tests|
|windows-amd64|Validate language-scope Example|build status doesn't match: PASS != FAIL|8.75 s|Local Example Tests|
|windows-amd64|NXP::FRDM-K32L3A6_BSP.17.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|23.57 s|Pack Example Tests|
|windows-amd64|NXP::LPCXpresso55S69_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|12.32 s|Pack Example Tests|
|windows-amd64|NXP::LPCXpresso55S69_USB_Examples.1.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|30.55 s|Pack Example Tests|
|windows-amd64|NXP::FRDM-K32L3A6_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|8.08 s|Pack Example Tests|
|windows-amd64|NXP::MIMXRT1060-EVKB_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|16.00 s|Pack Example Tests|
|windows-amd64|Blinky_NUCLEO-G0B1RE|build status doesn't match: FAIL != PASS|42.22 s|Remote Example Tests|
|windows-amd64|Blinky_NUCLEO-F756ZG|build status doesn't match: FAIL != PASS|44.33 s|Remote Example Tests|
|linux-amd64|Validate build-asm Example|build status doesn't match: PASS != FAIL|4.49 s|Local Example Tests|
|linux-amd64|Validate include-define Example|build status doesn't match: FAIL != PASS|1.36 s|Local Example Tests|
|linux-amd64|Validate language-scope Example|build status doesn't match: PASS != FAIL|2.21 s|Local Example Tests|
|linux-amd64|NXP::FRDM-K32L3A6_BSP.17.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|12.43 s|Pack Example Tests|
|linux-amd64|NXP::LPCXpresso55S69_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|7.63 s|Pack Example Tests|
|linux-amd64|NXP::LPCXpresso55S69_USB_Examples.1.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|15.19 s|Pack Example Tests|
|linux-amd64|NXP::FRDM-K32L3A6_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|5.31 s|Pack Example Tests|
|linux-amd64|NXP::MIMXRT1060-EVKB_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|9.13 s|Pack Example Tests|
|linux-amd64|Blinky_NUCLEO-G0B1RE|build status doesn't match: FAIL != PASS|10.70 s|Remote Example Tests|
|linux-amd64|Blinky_NUCLEO-F756ZG|build status doesn't match: FAIL != PASS|12.31 s|Remote Example Tests|
|darwin-amd64|Validate build-asm Example|build status doesn't match: PASS != FAIL|11.88 s|Local Example Tests|
|darwin-amd64|Validate include-define Example|build status doesn't match: FAIL != PASS|4.25 s|Local Example Tests|
|darwin-amd64|Validate language-scope Example|build status doesn't match: PASS != FAIL|7.10 s|Local Example Tests|
|darwin-amd64|NXP::FRDM-K32L3A6_BSP.17.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|31.85 s|Pack Example Tests|
|darwin-amd64|NXP::LPCXpresso55S69_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|19.25 s|Pack Example Tests|
|darwin-amd64|NXP::LPCXpresso55S69_USB_Examples.1.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|44.59 s|Pack Example Tests|
|darwin-amd64|NXP::FRDM-K32L3A6_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|13.90 s|Pack Example Tests|
|darwin-amd64|NXP::MIMXRT1060-EVKB_BSP.18.0.0|Unexpected status returned by cbuildgen execution: 1 != 0|25.17 s|Pack Example Tests|
|darwin-amd64|Blinky_NUCLEO-G0B1RE|build status doesn't match: FAIL != PASS|27.46 s|Remote Example Tests|
|darwin-amd64|Blinky_NUCLEO-F756ZG|build status doesn't match: FAIL != PASS|40.96 s|Remote Example Tests|