################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"../Sources/CAM.c" \
"../Sources/CAR.c" \
"../Sources/Events.c" \
"../Sources/MOTOR.c" \
"../Sources/PCCOM.c" \
"../Sources/TIME.c" \
"../Sources/main.c" \

C_SRCS += \
../Sources/CAM.c \
../Sources/CAR.c \
../Sources/Events.c \
../Sources/MOTOR.c \
../Sources/PCCOM.c \
../Sources/TIME.c \
../Sources/main.c \

OBJS += \
./Sources/CAM_c.obj \
./Sources/CAR_c.obj \
./Sources/Events_c.obj \
./Sources/MOTOR_c.obj \
./Sources/PCCOM_c.obj \
./Sources/TIME_c.obj \
./Sources/main_c.obj \

OBJS_QUOTED += \
"./Sources/CAM_c.obj" \
"./Sources/CAR_c.obj" \
"./Sources/Events_c.obj" \
"./Sources/MOTOR_c.obj" \
"./Sources/PCCOM_c.obj" \
"./Sources/TIME_c.obj" \
"./Sources/main_c.obj" \

C_DEPS += \
./Sources/CAM_c.d \
./Sources/CAR_c.d \
./Sources/Events_c.d \
./Sources/MOTOR_c.d \
./Sources/PCCOM_c.d \
./Sources/TIME_c.d \
./Sources/main_c.d \

OBJS_OS_FORMAT += \
./Sources/CAM_c.obj \
./Sources/CAR_c.obj \
./Sources/Events_c.obj \
./Sources/MOTOR_c.obj \
./Sources/PCCOM_c.obj \
./Sources/TIME_c.obj \
./Sources/main_c.obj \

C_DEPS_QUOTED += \
"./Sources/CAM_c.d" \
"./Sources/CAR_c.d" \
"./Sources/Events_c.d" \
"./Sources/MOTOR_c.d" \
"./Sources/PCCOM_c.d" \
"./Sources/TIME_c.d" \
"./Sources/main_c.d" \


# Each subdirectory must supply rules for building sources it contributes
Sources/CAM_c.obj: ../Sources/CAM.c
	@echo 'Building file: $<'
	@echo 'Executing target #1 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/CAM.args" -o "Sources/CAM_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/%.d: ../Sources/%.c
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/CAR_c.obj: ../Sources/CAR.c
	@echo 'Building file: $<'
	@echo 'Executing target #2 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/CAR.args" -o "Sources/CAR_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/Events_c.obj: ../Sources/Events.c
	@echo 'Building file: $<'
	@echo 'Executing target #3 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/Events.args" -o "Sources/Events_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/MOTOR_c.obj: ../Sources/MOTOR.c
	@echo 'Building file: $<'
	@echo 'Executing target #4 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/MOTOR.args" -o "Sources/MOTOR_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/PCCOM_c.obj: ../Sources/PCCOM.c
	@echo 'Building file: $<'
	@echo 'Executing target #5 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/PCCOM.args" -o "Sources/PCCOM_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/TIME_c.obj: ../Sources/TIME.c
	@echo 'Building file: $<'
	@echo 'Executing target #6 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/TIME.args" -o "Sources/TIME_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '

Sources/main_c.obj: ../Sources/main.c
	@echo 'Building file: $<'
	@echo 'Executing target #7 $<'
	@echo 'Invoking: ColdFire Compiler'
	"$(CF_ToolsDirEnv)/mwccmcf" @@"Sources/main.args" -o "Sources/main_c.obj" "$<" -MD -gccdep
	@echo 'Finished building: $<'
	@echo ' '


