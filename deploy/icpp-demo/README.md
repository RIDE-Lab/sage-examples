# SAGE ICPP Demo — Docker 启动入口

公开镜像：[liujun4hust/sage-icpp-demo:20260921](https://hub.docker.com/r/liujun4hust/sage-icpp-demo/tags?name=20260921)。

安装并启动支持 **Linux 容器**的 Docker（包含 Compose）。镜像为 Linux AMD64；Windows、macOS 和 ARM64 本地运行尚未实机验证。

## 从 Docker Hub 拉取并启动

下载此分支的仓库 ZIP 并解压，或执行：

```sh
git clone --branch icpp-demo --single-branch https://github.com/intellistream/sage-examples.git
cd sage-examples/deploy/icpp-demo
```

Windows PowerShell：

```powershell
.\scripts\start-hub.ps1
```

Linux/macOS shell：

```sh
sh scripts/start-hub.sh
```

脚本会拉取镜像、创建数据卷、启动前后端服务并等待健康检查。打开 **http://localhost:18400/ui/**，再选择并启动演示应用。不需要 SSH、server4 或机房网络；首次拉取需能访问 Docker Hub。

不用脚本也可以执行：

```text
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml pull
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml up -d --pull never --no-build --wait
```

已下载镜像后，第二条命令可离线启动。停止并保留数据：

```text
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml down
```

请勿添加 `-v`，除非有意删除数据卷。重启容器后需从网页重新启动应用进程。

## 演示与模型配置

Ticket Triage、Supply Chain Alert 的规则流程和 Data Cleaner 不依赖模型服务，执行真实数据处理。可选自然语言解释需要配置可达的 LLM，默认显示未配置。

详见 [Docker Hub 使用与模型配置](HUB-DEMO.md)。可以在此目录创建 `.env`，设置 `SAGE_LLM_BASE_URL`、`SAGE_LLM_MODEL`、`SAGE_OPENAI_API_KEY`，再执行 `up` 重建容器。Embedding 和 reranker 使用独立端点；不要将 reranker 配为 embedding。不要提交含密钥的 `.env`。

## 完全离线分发

若用户无法访问 Docker Hub，可另行提供已导出的镜像归档；Git 仓库不存储镜像大文件。将归档放到本目录的 `artifacts/sage-icpp-demo-20260921.tar` 后，运行 `scripts/start-local.sh` 或 `scripts/start-local.ps1`。

详见 [离线使用说明](LOCAL-DEMO.md)。本地归档配置与 Hub 配置使用不同 Compose 项目及数据卷；从一种方式切换到另一种方式前先停止旧容器，以免端口冲突。

## 版本与实测范围

- 镜像 manifest digest：`sha256:8d3faa63cdbffaaf757f08424ff3baa5b84c82dd5104a69195a41132cfd5fad7`。
- Docker image ID：`sha256:c1cafc1b6c2e8c7adada213cda27be7b950b5ceffdfba436f6ed29981ba12581`。
- Docker-save 归档 SHA256：`66042fda1ed39a007a9ffafbf515c8b90f23424b15ea41947c51977f74382463`。
- Linux AMD64：健康、前端资源、104 个入口发现及三个代表应用通过。104 个入口不代表全部应用验证通过。
- Ticket：10 工单、5 高优先级；Supply：10 事件、8 告警；Cleaner：真实非零输出和算子指标。
- 完全禁用容器网络后上述三个应用仍通过。已验证持久化、容器重启和模型不可达状态。
- 已匿名完整下载公开镜像，校验摘要一致，并导入 Docker 再次验证启动、健康和前端资源。
- 当前测试宿主无法直连 Docker Hub，因此注册表下载和 Docker 运行分别在可联网客户端与 Linux 宿主完成；未声称在该宿主跑通完整 `pull` 启动脚本。PowerShell 尚未在 Windows 执行。

网页仅映射到本机 `127.0.0.1`，应用仪表盘通过同源代理访问。镜像不包含模型权重或 GPU 推理环境。
