#!/bin/bash

# 循环控制配置
# 核心控制变量
# 外层循环总开关（true=继续，false=结束）
OUTER_LOOP_ENABLED=true
# 内层循环要跑几次
INNER_LOOP_COUNT=3
# 倒计时秒数（从环境变量读取）
COUNTDOWN_SECONDS=10

# 你要执行的命令（可自定义）
FIRST_RUN_CMD="echo "进入外层循环 → 首次执行命令""
INNER_LOOP_CMD="echo "执行内层循环任务""
AFTER_COUNTDOWN_CMD="echo "倒计时结束 → 执行最终命令""


# 定义所有需要导出的变量列表
CONFIG_LIST=(
    OUTER_LOOP_ENABLED
    INNER_LOOP_COUNT
    COUNTDOWN_SECONDS
    FIRST_RUN_CMD
    INNER_LOOP_CMD
    AFTER_COUNTDOWN_CMD
)

# 自动写入 GITHUB_ENV（所有变量全局生效）
for CONFIG in "${CONFIG_LIST[@]}"; do
    VALUE="${!CONFIG}"
    echo "${CONFIG}=${VALUE}"
    echo "${CONFIG}=${VALUE}" >> $GITHUB_ENV
    echo "===================================================================="
done

echo "✅ 循环参数配置写入完成"
