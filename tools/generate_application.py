from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf"
OUT.mkdir(parents=True, exist_ok=True)
PDF_PATH = OUT / "MoonAuditChainKit_项目申报书.pdf"

FONT = "Helvetica"
for candidate in [Path("C:/Windows/Fonts/msyh.ttc"), Path("C:/Windows/Fonts/simhei.ttf"), Path("C:/Windows/Fonts/simsun.ttc")]:
    if candidate.exists():
        pdfmetrics.registerFont(TTFont("CNFont", str(candidate)))
        FONT = "CNFont"
        break

styles = getSampleStyleSheet()
title = ParagraphStyle("TitleCN", parent=styles["Title"], fontName=FONT, fontSize=19, leading=25, textColor=colors.HexColor("#17395f"), alignment=1, spaceAfter=16)
section = ParagraphStyle("SectionCN", parent=styles["Heading2"], fontName=FONT, fontSize=12, leading=16, textColor=colors.HexColor("#17395f"), spaceBefore=7, spaceAfter=5)
body = ParagraphStyle("BodyCN", parent=styles["BodyText"], fontName=FONT, fontSize=9.5, leading=14, spaceAfter=5)
cell = ParagraphStyle("CellCN", parent=body, leading=13, spaceAfter=0)


def p(text, style=body):
    return Paragraph(text, style)


story = [p("MoonAuditChainKit 项目申报书", title)]
rows = [
    ("项目名称", "MoonAuditChainKit：面向 MoonBit 的不可篡改审计日志链基础库"),
    ("参赛者", "刘炳宏"),
    ("联系方式", "18276127853"),
    ("GitHub 仓库", "https://github.com/Lbh-code78/MoonAuditChainKit"),
    ("GitLink 仓库", "https://www.gitlink.org.cn/Lbh9898/MoonAuditChainKit"),
    ("项目方向", "MoonBit 数据治理 / 审计追踪 / 完整性验证基础设施"),
    ("是否移植", "否，原创 MoonBit 基础库项目"),
]
table = Table([[p(k, cell), p(v, cell)] for k, v in rows], colWidths=[34 * mm, 146 * mm])
table.setStyle(TableStyle([
    ("FONTNAME", (0, 0), (-1, -1), FONT),
    ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#eaf2fb")),
    ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor("#17395f")),
    ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#b7c8d8")),
    ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
    ("LEFTPADDING", (0, 0), (-1, -1), 7),
    ("RIGHTPADDING", (0, 0), (-1, -1), 7),
    ("TOPPADDING", (0, 0), (-1, -1), 5),
    ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
]))
story += [table, Spacer(1, 8)]

sections = [
    ("一、项目简介", "MoonAuditChainKit 面向 MoonBit 生态提供不可篡改审计日志链能力。项目通过事件规范化、记录摘要、前后摘要串联和验证报告，让配置变更、部署操作、CI 步骤和数据治理事件具备可追踪、可校验的证据链。"),
    ("二、核心功能", "项目已实现 AuditEvent、AuditRecord、AuditChain、VerifyReport、ChainProof 与 JSON 导出，支持事件追加、摘要串联、链完整性验证、首个异常位置定位、链头证明和 CLI 演示。"),
    ("三、创新点和价值", "普通日志只能记录发生过什么，但很难发现中间记录被改写、删除或重排。MoonAuditChainKit 把审计事件组织成 digest chain，任何一处变化都会破坏后续链路，可用于操作审计、配置追踪、构建证据和数据治理场景。"),
    ("四、与社区项目差异", "项目不做日志 sink、DataFrame、SQL codegen、Web 框架或通用加密库。它专注审计事件之间的完整性关系，可与日志系统组合，但边界是审计证据链而不是日志输出。"),
    ("五、当前完成情况", "仓库包含 MoonBit 源码、8 个回归测试、CLI 示例、README、RELATED_WORK、ACCEPTANCE、CHANGELOG、GitHub Actions CI、接口元数据和本申报书。当前可运行 moon check --target all、moon test --target wasm、moon test --target wasm-gc、moon test --target js 与 moon run cmd/main。"),
    ("六、技术路线", "第一阶段提供确定性摘要链和验证报告；第二阶段补充可插拔加密摘要、批量导入导出和链段验证；第三阶段提供配置审计、CI 审计和数据血缘等示例。"),
    ("七、验收与质量保障", "CI 使用官方 MoonBit 安装流程，并执行 check、test、fmt diff、moon info diff 和 CLI 演示。测试覆盖事件规范化、摘要确定性、链追加、完整性验证、异常定位、proof 和 JSON 输出。"),
    ("八、后续计划", "继续补充 Merkle checkpoint、外部 hash 后端、审计事件模板、benchmark、错误案例文档和可视化链路示例。"),
    ("九、提交说明", "项目围绕公开仓库分步骤提交，每个提交对应一个可解释功能或材料节点，便于评审追踪开发过程。"),
]
for heading, text in sections:
    story += [p(heading, section), p(text)]

doc = SimpleDocTemplate(str(PDF_PATH), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm, topMargin=18 * mm, bottomMargin=18 * mm)
doc.build(story)
print(PDF_PATH)
