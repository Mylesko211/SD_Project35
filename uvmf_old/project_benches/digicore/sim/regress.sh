#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

TESTPLAN_XML="${TESTPLAN_XML:-${SCRIPT_DIR}/digicore_merged_test_plan.xml}"
TESTPLAN_UCDB=""
MERGED_UCDB="${MERGED_UCDB:-${SCRIPT_DIR}/sim_and_testplan_merged.ucdb}"
OPEN_VISUALIZER="${OPEN_VISUALIZER:-1}"
SKIP_CLEAN="${SKIP_CLEAN:-0}"
CODE_COVERAGE_ENABLE="${CODE_COVERAGE_ENABLE:-1}"
CODE_COVERAGE_TARGET="${CODE_COVERAGE_TARGET:-/hdl_top/dut_verilog.}"

TESTS=(
  "reg_map_sweep_test:193456"
)

require_tool() {
  local tool_name="$1"
  local help_text="$2"
  if ! command -v "${tool_name}" >/dev/null 2>&1; then
    echo "Missing required tool: ${tool_name}" >&2
    echo "${help_text}" >&2
    exit 127
  fi
}

preflight_checks() {
  require_tool vlib "Questa/ModelSim is not on PATH. Load your simulator environment before running regress.sh."
  require_tool vlog "Questa/ModelSim is not on PATH. Load your simulator environment before running regress.sh."
  require_tool vsim "Questa/ModelSim is not on PATH. Load your simulator environment before running regress.sh."
  require_tool xml2ucdb "xml2ucdb is not on PATH. Load the Questa coverage tools before running regress.sh."
  require_tool vcover "vcover is not on PATH. Load the Questa coverage tools before running regress.sh."
  if [[ "${OPEN_VISUALIZER}" == "1" ]]; then
    require_tool visualizer "Visualizer is not on PATH. Either load the GUI tools or run with OPEN_VISUALIZER=0."
  fi
}

resolve_testplan() {
  local xml_candidates=()

  if [[ ! -f "${TESTPLAN_XML}" ]]; then
    mapfile -t xml_candidates < <(find "${SCRIPT_DIR}" -maxdepth 1 -type f -name '*.xml' | sort)
    if [[ "${#xml_candidates[@]}" -eq 1 ]]; then
      TESTPLAN_XML="${xml_candidates[0]}"
      echo "Using discovered test plan: ${TESTPLAN_XML}"
    else
      echo "Could not find configured test plan: ${TESTPLAN_XML}" >&2
      echo "Set TESTPLAN_XML=/full/path/to/your_plan.xml when running regress.sh." >&2
      if [[ "${#xml_candidates[@]}" -gt 0 ]]; then
        echo "Available XML files:" >&2
        printf '  %s\n' "${xml_candidates[@]}" >&2
      fi
      exit 2
    fi
  fi

  TESTPLAN_UCDB="${TESTPLAN_XML%.xml}.ucdb"
}

run_test() {
  local test_name="$1"
  local test_seed="$2"
  local make_target="$3"

  echo "Running ${test_name} with seed ${test_seed} via ${make_target}"
  make "${make_target}" \
    TEST_NAME="${test_name}" \
    TEST_SEED="${test_seed}" \
    CODE_COVERAGE_ENABLE="${CODE_COVERAGE_ENABLE}" \
    CODE_COVERAGE_TARGET="${CODE_COVERAGE_TARGET}" \
    UVMF_SIM_FLAGS="-uvm_set_verbosity=,UVM_LOW -enable_trlog -use_vis_uvm" \
    2>&1 | tee run.log

  cp run.log "transcripts/${test_name}_transcript.log"

  if [[ -f "${test_name}.ucdb" ]]; then
    cp "${test_name}.ucdb" ".ucdb/${test_name}.ucdb"
  fi
}

echo "Regression setup:"
echo "  OPEN_VISUALIZER=${OPEN_VISUALIZER}"
echo "  SKIP_CLEAN=${SKIP_CLEAN}"
echo "  If your terminal auto-closes on errors, run after your simulator environment is loaded."

preflight_checks
resolve_testplan

if [[ "${SKIP_CLEAN}" != "1" ]]; then
  make clean
fi

rm -rf transcripts ./.ucdb "${TESTPLAN_UCDB}" "${MERGED_UCDB}"
mkdir -p transcripts ./.ucdb

first=1
for entry in "${TESTS[@]}"; do
  test_name="${entry%%:*}"
  test_seed="${entry##*:}"
  if [[ "${first}" -eq 1 ]]; then
    run_test "${test_name}" "${test_seed}" "cli"
    first=0
  else
    run_test "${test_name}" "${test_seed}" "run_cli"
  fi
done

xml2ucdb -format Excel "${TESTPLAN_XML}" "${TESTPLAN_UCDB}"
vcover merge -stats=none -strip 0 -totals "${MERGED_UCDB}" ./.ucdb/*.ucdb "${TESTPLAN_UCDB}"

if [[ "${OPEN_VISUALIZER}" == "1" ]]; then
  visualizer -viewcov "${MERGED_UCDB}"
else
  echo "Merged coverage written to ${MERGED_UCDB}"
  echo "Set OPEN_VISUALIZER=1 to launch Visualizer after regression."
fi
