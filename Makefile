#####################################################################
## file        : test makefile for build current dir .c            ##
## author      : x                                         ##
## date-time   : 12/12/2025                                        ##
#####################################################################

#此功能是编译当前所有文件的c或cpp的文件。
CC      = gcc
CPP     = g++
RM      = rm -rf

#PROJECT_ROOT_PATH := /home/swoole/test/project
#mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))  #获取当前正在执行的makefile的绝对路径
#cur_makefile_path := patsubst$(%/, %, dir $(mkfile_patch))  #获取当前正在执行的makefile的绝对目录

##	@echo mkfile_path=$(mkfile_path)
##	@echo cur_makefile_path=$(cur_makefile_path)
## debug flag
DBG_ENABLE   = 1

## source file path
        SRC_PATH   := .

## get all source files
SRCS         += $(wildcard $(SRC_PATH)/*.c)

## target exec file name
TARGET     := httpd
#TARGET = $(patsubst %.cpp, %, ${SRCS})

## all .o based on all .c
OBJS        := $(SRCS:.c=.o)

#gcc -o subpub subpub.c -I /usr/local/include/hiredis/ -lhiredis -levent

## need libs, add at here
#LIBS := pthread mysqlclient hiredis
LIBS := pthread
#LIBS := pthread  hiredis event

## used headers  file path
# INCLUDE_PATH := . /usr/local/include/ /usr/local/include/hiredis/ /usr/local/include/mysql/ /usr/local/include/libwebsockets/
# 先备份
INCLUDE_PATH := . /usr/local/include/


#-I./指定出ae.h头文件的位置

#/usr/local/lib/libhiredis.a /usr/local/include/hiredis/libae.a
## used include librarys file path
#LIBRARY_PATH := . /usr/local/lib /usr/local/mysql/lib
LIBRARY_PATH := . /usr/local/lib

## debug for debug info, when use gdb to debug
#-Wl,--no-as-needed  -lm 解决cjson编译选项问题
ifeq (1, ${DBG_ENABLE})
	CFLAGS += -D_DEBUG -O0 -g -DDEBUG=1  -Wl,--no-as-needed  -lm
endif

## get all include path
CFLAGS  += $(foreach dir, $(INCLUDE_PATH), -I$(dir))

## get all library path
LDFLAGS += $(foreach lib, $(LIBRARY_PATH), -L$(lib))

## get all librarys
LDFLAGS += $(foreach lib, $(LIBS), -l$(lib))

all: clean build
build:
	$(CC) -c $(CFLAGS) $(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)
	$(RM) $(OBJS)

clean:
	$(RM) $(OBJS) $(TARGET)
