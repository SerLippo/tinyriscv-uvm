import os
import re
import logging
import argparse
import subprocess
import random
import datetime

prefix = '        '
regs = ['x0', 'x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7',
        'x8', 'x9', 'x10', 'x11', 'x12', 'x13', 'x14', 'x15',
        'x16', 'x17', 'x18', 'x19', 'x20', 'x21', 'x22', 'x23',
        'x24', 'x25', 'x26', 'x27', 'x28', 'x29', 'x30', 'x31']


def parseArgs():
    pass


def asm_init(asm):
    asm.append(prefix + '.equ shake_hand_addr, 0x1FFFFFFC')
    asm.append(prefix + '.equ shake_done_pass_data, 0xEDEDAAAA')
    asm.append(prefix + '.equ shake_done_fail_data, 0xEDEDFFFF')
    asm.append(prefix + '.section .text')
    asm.append(prefix + '.align 6')
    asm.append(prefix + '.globl _start')
    asm.append('_start:')
    for reg in regs:
        asm.append(prefix + 'li {:s}, 0x{:X}'.format(reg, random.getrandbits(32)))


def asm_main(asm):
    asm.append(prefix + 'add x1, x2, x3')
    asm.append(prefix + 'add x1, x2, x3')
    asm.append(prefix + 'add x1, x2, x3')
    asm.append(prefix + 'j pass')


def asm_end(asm):
    rand_reg = regs
    rand_reg.remove('x0')
    random.shuffle(rand_reg)
    asm.append('fail:')
    asm.append(prefix + 'li {:s}, shake_hand_addr'.format(rand_reg[0]))
    asm.append(prefix + 'li {:s}, shake_done_fail_data'.format(rand_reg[1]))
    asm.append(prefix + 'sw {:s}, 0({:s})'.format(rand_reg[1], rand_reg[0]))
    asm.append(prefix + 'j loop')
    asm.append('pass:')
    asm.append(prefix + 'li {:s}, shake_hand_addr'.format(rand_reg[0]))
    asm.append(prefix + 'li {:s}, shake_done_pass_data'.format(rand_reg[1]))
    asm.append(prefix + 'sw {:s}, 0({:s})'.format(rand_reg[1], rand_reg[0]))
    asm.append(prefix + 'j loop')
    asm.append('loop:')
    asm.append(prefix + 'j loop')


def asm_data(asm):
    asm.append(prefix + '.section .data')
    asm.append(prefix + '.align 6')
    asm.append('data0:')
    asm.append(prefix + '.dword 0x1')


def runCmd(cmd, tmoutSecond=600, exitOnError=True):
    logging.info(cmd)
    try:
        ps = subprocess.Popen(
            "exec " + cmd,
            shell=True,
            executable='/bin/bash',
            universal_newlines=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
    except subprocess.CalledProcessError:
        logging.error(ps.commuicate()[0])
        raise Exception("<Command Error> Subprocess running failed.")
    except KeyboardInterrupt:
        logging.debug("\nExited Ctrl-C from user request.")
        raise KeyboardInterrupt("<Keyboard Error> Exited Ctrl+C from user request.")
    try:
        output = ps.communicate(timeout=tmoutSecond)[0]
    except subprocess.TimeoutExpired:
        logging.error("Timeout[%ds]: %s"%(tmoutSecond, cmd))
        output = ""
        ps.kill()
        raise Exception("<Command Error> Subprocess timeout.")
    rc = ps.returncode
    if rc and rc > 0:
        logging.debug(output)
        logging.error("Error return code: %s"%rc)
        if exitOnError:
            raise Exception("<Command Error> Subprocess running failed with return code: %s."%rc)
    logging.debug(output)
    return output


def main():
    cwd = os.getcwd()
    FORMAT = '%(asctime)-15s %(levelname)s: %(message)s'
    logging.basicConfig(format=FORMAT,level=logging.INFO)
    logging.info('Starting to run asm_gen script in directory: {}'.format(cwd))

    asmList = []
    asm_init(asmList)
    asm_main(asmList)
    asm_end(asmList)
    asm_data(asmList)

    with open('asm.s', 'w') as f:
        for line in asmList:
            f.write(line + '\n')

    cmd_cp = 'cp $REPO_BASE/verif/soc/asm/link.ld ./'
    cmd_gcc = '$TOOLCHAIN_BASE/riscv64-unknown-elf-gcc -static -mcmodel=medany \
-fvisibility=hidden -nostdlib -nostartfiles -march=rv32im -mabi=ilp32 \
-Tlink.ld asm.s -o asm.out'
    cmd_objdump = '$TOOLCHAIN_BASE/riscv64-unknown-elf-objdump --disassemble-all asm.out > asm.D'
    cmd_objcopy = '$TOOLCHAIN_BASE/riscv64-unknown-elf-objcopy -O binary asm.out asm.bin'
    runCmd(cmd_cp)
    runCmd(cmd_gcc)
    runCmd(cmd_objdump)
    runCmd(cmd_objcopy)
    logging.info('Finishing to run asm_gen script in directory: {}'.format(cwd))


if __name__ == "__main__":
    main()