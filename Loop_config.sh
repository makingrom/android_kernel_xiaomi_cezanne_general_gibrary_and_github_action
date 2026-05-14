# 循环控制配置
# 核心控制变量
OUTER_LOOP_ENABLED=true# 外层循环总开关（true=继续，false=结束）
INNER_LOOP_COUNT=3# 内层循环要跑几次
COUNTDOWN_SECONDS=10# 倒计时秒数（从环境变量读取）

# 你要执行的命令（可自定义）
FIRST_RUN_CMD=echo "进入外层循环 → 首次执行命令"
INNER_LOOP_CMD=echo "执行内层循环任务"
AFTER_COUNTDOWN_CMD=echo "倒计时结束 → 执行最终命令"
