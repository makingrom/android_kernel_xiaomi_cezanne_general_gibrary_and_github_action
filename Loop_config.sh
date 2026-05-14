#!/bin/bash

# 循环核心控制配置

#!/bin/bash
set -euo pipefail

# ============================
# 【固定写在脚本内部】无需依赖环境变量传递
# 这是最稳定、不会空、不会报错的方案
# ============================
OUTER_LOOP_ENABLED="true"
INNER_LOOP_COUNT="3"
COUNTDOWN_SECONDS="10"

FIRST_RUN_CMD="echo '进入外层循环 → 首次执行命令'"
INNER_LOOP_CMD="echo '执行内层循环任务'"
AFTER_COUNTDOWN_CMD="echo '倒计时结束 → 执行最终命令'"

# ============================
# 【真正的循环逻辑】
# ============================
echo -e "\n====================================="
echo "🔁 开始外层循环"
echo "====================================="

# 进入外层循环先执行
echo -e "\n🚀 执行首次命令"
eval "$FIRST_RUN_CMD"

# 内层循环
echo -e "\n🔢 开始内层循环，共 $INNER_LOOP_COUNT 次"
for ((i=1; i<=INNER_LOOP_COUNT; i++)); do
    echo "→ 内层循环 $i"
    eval "$INNER_LOOP_CMD"
done

# 倒计时
echo -e "\n⏳ 倒计时 $COUNTDOWN_SECONDS 秒..."
for ((sec=COUNTDOWN_SECONDS; sec>0; sec--)); do
    echo "倒计时：$sec 秒"
    sleep 1
done

# 倒计时结束执行
echo -e "\n✅ 倒计时结束"
eval "$AFTER_COUNTDOWN_CMD"

# 判断是否继续
if [[ "$OUTER_LOOP_ENABLED" == "false" ]]; then
    echo -e "\n❌ 外层循环关闭，退出"
else
    echo -e "\n✅ 外层循环开启，继续运行"
fi

echo -e "\n🎉 脚本执行完成"

# # 外层循环总开关（true=继续，false=结束）
# OUTER_LOOP_ENABLED=true
# # 内层循环要跑几次
# INNER_LOOP_COUNT=3
# # 倒计时秒数（从环境变量读取）
# COUNTDOWN_SECONDS=10

# # 你要执行的命令（可自定义）
# FIRST_RUN_CMD="echo '进入外层循环 → 首次执行命令'"
# INNER_LOOP_CMD="echo '执行内层循环任务'"
# AFTER_COUNTDOWN_CMD="echo '倒计时结束 → 执行最终命令'"


# # 定义所有需要导出的变量列表
# CONFIG_LIST=(
#     OUTER_LOOP_ENABLED
#     INNER_LOOP_COUNT
#     COUNTDOWN_SECONDS
#     FIRST_RUN_CMD
#     INNER_LOOP_CMD
#     AFTER_COUNTDOWN_CMD
# )

# # 自动写入 GITHUB_ENV（所有变量全局生效）
# for CONFIG in "${CONFIG_LIST[@]}"; do
#     VALUE="${!CONFIG}"
#     echo "${CONFIG}=${VALUE}"
#     echo "${CONFIG}=${VALUE}" >> $GITHUB_ENV
#     echo "===================================================================="
# done

# echo "✅ 循环参数配置写入完成"
