# 焦点修复定向验证记录（2026-03-03）

## 自动化执行

### 用例：`搜索页_结果焦点下移_首个卡片出现焦点放大`
- 命令：`IT_ENABLE_SCREENSHOT=0 bash script/run_it_tv.sh quick --allow-name --name "搜索页_结果焦点下移_首个卡片出现焦点放大" --device 192.168.145.55:5555`
- 结果：通过
- 关键日志：
  - 安装：`197.7s`
  - 结束：`All tests passed!`

### 用例：`搜索页_关键词搜索_空结果提示可见|搜索页_结果焦点下移_首个卡片出现焦点放大`（批跑）
- 命令：`bash script/run_it_tv.sh quick --allow-name --name "<两个用例正则>" --device 192.168.145.55:5555`
- 结果：失败（`IsarError: Instance has already been opened`）
- 结论：失败原因为测试间共享状态，不是焦点功能本身回归。

## 手测收口
- 当前已完成自动化定向验证收口。
- 受 Wi-Fi ADB 速度与稳定性影响，建议在后续提速入口稳定后补一次遥控器人工手测（首页进入搜索、下移焦点、返回链路）。
