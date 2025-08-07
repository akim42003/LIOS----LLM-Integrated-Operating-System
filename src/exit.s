#PURPOSE: Simple program that exits and returns status back to kernel

#INPUT: none

#OUTPUT: exit status code. Can be viewed with echo $?

#VARIABLES
#
#   %eax
#   %ebx

.section .data

.section .text

.globl _start

_start:

movl $1, %eax # kernel command number for exiting a program

movl $0, %ebx # status number we will return

int $0x80 #wakes kernel to run int stands for interrupt
