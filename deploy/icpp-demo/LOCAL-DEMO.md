# 无内网连接时，在自己电脑运行 Demo

本地演示不需要 SSH、server4、机房公网映射或 server3 模型服务。先把发行包复制到电脑，安装并启动支持 Linux 容器的 Docker（包含 Compose），即可导入镜像运行；启动过程不会拉取镜像或安装依赖。

已验证 Linux AMD64。Windows 需要支持 Linux 容器的 Docker 环境；Windows、macOS 和 ARM64 未实机验证，镜像只包含 AMD64 依赖。

## 最短操作

解压 `sage-icpp-demo-local-20260921.zip`，进入解压目录。

Windows PowerShell：

```powershell
.\scripts\start-local.ps1
```

Linux/macOS shell：

```sh
sh scripts/start-local.sh
```

打开 **http://localhost:18400/ui/**。应用、网页、数据和计算都运行在自己的 Docker 中。

也可直接执行以下两条命令（PowerShell 和 shell 相同，无需执行脚本）：

```text
docker load -i artifacts/sage-icpp-demo-20260921.tar
docker compose -p sage-icpp-demo-local -f compose.local.yaml up -d --pull never --no-build --wait
```

若 18400 被占用，PowerShell 先执行 `$env:LOCAL_DEMO_PORT="18410"`；shell 使用 `LOCAL_DEMO_PORT=18410 sh scripts/start-local.sh`，随后打开 http://localhost:18410/ui/。

## 可离线演示的内容

1. Ticket Triage：启动应用，运行 Demo Flow，查看 10 个工单、5 个高优先级工单及指标。
2. Supply Chain Alert：启动应用，运行 Demo Flow，查看 10 个事件、8 条规则告警和仪表盘。
3. Data Cleaner：查看 Test Data，在 Request Lab 提交 CSV，查看真实清洗结果和算子指标。

以上是实际执行的规则与数据处理，不是伪造模型回复。自然语言风险解释需要另外配置可达的 LLM；本地配置默认不连接模型，诊断显示未配置，解释功能明确提示不可用。其他发现的入口不代表已验证可用。

`compose.local.yaml` 显式清空模型端点，与面向机房部署的 `compose.yaml` 分开；本地运行不要复制机房 `.env.example` 或使用旧 `run.sh`。网页和应用仪表盘使用同源代理，只需映射一个端口。

## 停止与再次启动

```text
docker compose -p sage-icpp-demo-local -f compose.local.yaml down
docker compose -p sage-icpp-demo-local -f compose.local.yaml up -d --pull never --no-build --wait
```

数据保留在 Docker 命名卷中。重启后需重新启动应用进程；支持持久化的业务存储可继续使用。不要加 `down -v`，它会删除演示数据。

## 校验与验证边界

镜像归档 SHA256：`66042fda1ed39a007a9ffafbf515c8b90f23424b15ea41947c51977f74382463`。

PowerShell：`Get-FileHash artifacts/sage-icpp-demo-20260921.tar -Algorithm SHA256`；Linux：`sha256sum -c artifacts/SHA256SUMS`；macOS：`shasum -a 256 -c artifacts/SHA256SUMS`。从解压根目录执行。

已用相同镜像在 Docker `--network none` 下验证健康、资源、应用发现和上述三个应用；无模型环境变量、全新数据卷、无源码挂载。模型服务器连接得到 Network is unreachable，规则演示仍成功。该测试证明无需外部服务；正常用户配置采用普通 Docker 网络以便浏览器访问本机映射端口，并非网络防火墙隔离方案。
