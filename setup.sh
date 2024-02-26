export VCS_RUN=~/Projects/vrun
alias vrun="python3 $VCS_RUN/vrun.py"
export REPO_BASE=~/Projects/tinyriscv-uvm
export VERIF_BASE=$REPO_BASE/verif

alias tiny="vrun -cfg $VERIF_BASE/soc/yaml/tinyriscv.yaml -o $REPO_BASE/out"

alias cdv="cd $VERIF_BASE"
alias cdo="cd $REPO_BASE/out"

echo "================================================="
echo "source setup.sh in master branch"
echo "VCS command is:"
echo "tiny -test xxx -seed 123"
echo "================================================="