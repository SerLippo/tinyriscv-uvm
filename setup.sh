export VCS_RUN=~/Projects/vrun
alias vrun="python3 $VCS_RUN/vrun.py"
export REPO_BASE=~/Projects/tinyriscv-uvm
export VERIF_BASE=$REPO_BASE/verif
export TOOLCHAIN_BASE=$REPO_BASE/tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/bin

alias r_tiny="vrun -cfg $VERIF_BASE/soc/yaml/tinyriscv.yaml -o $REPO_BASE/out/soc"
alias r_gpio="vrun -cfg $VERIF_BASE/gpio/yaml/gpio.yaml -o $REPO_BASE/out/gpio"

alias cdr="cd $REPO_BASE"
alias cdv="cd $VERIF_BASE"
alias cdo="cd $REPO_BASE/out"

echo "================================================="
echo "source setup.sh in master branch"
echo "SoC VCS command is:"
echo "r_tiny -test xxx -seed 123 -fsdb"
echo "================================================="