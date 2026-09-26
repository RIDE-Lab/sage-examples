# 从 Docker Hub 启动 SAGE Demo

仓库：`liujun4hust/sage-icpp-demo`，版本：`20260926-cpu-full`，平台：Linux AMD64。

安装并启动支持 Linux 容器的 Docker（包含 Compose），解压启动包后：

Windows PowerShell：

```powershell
.\scripts\start-hub.ps1
```

Linux/macOS shell：

```sh
sh scripts/start-hub.sh
```

脚本拉取镜像、创建数据卷并启动服务，等待健康后打印地址。打开 http://localhost:18400/ui/ 。首次拉取需要访问 Docker Hub，运行无需 server4、SSH 或机房网络。

不使用脚本时，在解压目录执行：

```text
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml pull
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml up -d --pull never --no-build --wait
```

镜像已下载后，直接执行第二条命令即可离线启动。停止使用 `docker compose -p sage-icpp-demo-hub -f compose.hub.yaml down`，不加 `-v`，数据会保留。

默认无需模型，可运行 Ticket Triage、Supply Chain Alert 规则流程和 Data Cleaner。启动脚本自动从 `.env.example` 创建缺失的 `.env`，不会覆盖已有配置。可先运行 `sh scripts/start-hub.sh --init-env`（PowerShell：`.\scripts\start-hub.ps1 -InitEnvOnly`）只创建文件。可选 LLM 解释需设置可达的模型服务，编辑该 `.env`，按实际服务填写：

```dotenv
SAGE_LLM_BASE_URL=https://your-model-service/v1
SAGE_LLM_MODEL=your-model-name
SAGE_OPENAI_API_KEY=your-api-key
```

再次执行 `up` 命令会按新配置重新创建容器并保留数据卷。不要分发含密钥的 `.env`。Embedding 与 reranker 使用各自独立变量，不可混用；无需时保持空值。网页内实时编辑模型设置尚未实现。

只监听本机127.0.0.1。修改本机端口可在 `.env` 添加 `LOCAL_DEMO_PORT=18410`。应用仪表盘使用同源代理，无需额外端口。

Linux AMD64 镜像已完成健康、前端、三应用、模型不可达、持久化和全断网验证。Windows、macOS及ARM64本地运行未实机验证；Apple Silicon不属于已验证平台。发布版本及实测边界见 [README](README.md#版本与实测范围)。
