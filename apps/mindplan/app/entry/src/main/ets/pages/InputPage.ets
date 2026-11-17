import { BusinessError } from '@kit.BasicServicesKit'
import { AGCClient } from '../services/AGCClient'
import { AIResponse } from '../model/AIResponse'

interface ErrorInfo {
  error: string
}

@Component
export default struct InputPage {
  @State inputText: string = ''
  @State resultJson: string = ''
  @State isLoading: boolean = false
  @State statusMessage: string = '输入任务描述，点击按钮开始规划'

  build() {
    Column() {
      Column() {
        Text('🧠 MindPlan')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 32 })

        Text('输入任务，AI 帮你规划今日行程')
          .fontSize(14)
          .fontColor('#888888')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')

      Column() {
        TextInput({ placeholder: '输入任务描述，如：今天写周报、健身1小时、打电话给妈妈', text: this.inputText })
          .onChange((value: string) => { this.inputText = value })
          .height(48)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 12, right: 12 })
          .margin({ top: 24, bottom: 16 })

        Row() {
          Button('🏠 今日规划')
            .backgroundColor('#E8F0FE')
            .fontColor('#4A6CF7')
            .borderRadius(16)
            .fontSize(13)
            .height(32)
            .onClick(() => {
              this.inputText = '今天写周报、健身1小时、打电话给妈妈'
            })

          Button('📅 本周规划')
            .backgroundColor('#E8F0FE')
            .fontColor('#4A6CF7')
            .borderRadius(16)
            .fontSize(13)
            .height(32)
            .margin({ left: 8 })
            .onClick(() => {
              this.inputText = '本周完成项目报告、周三健身3次、周五前买礼物'
            })
        }

        Button(this.isLoading ? '生成中...' : '🚀 AI 生成计划')
          .width('100%')
          .height(44)
          .backgroundColor('#4A6CF7')
          .fontColor('#FFFFFF')
          .borderRadius(22)
          .fontSize(16)
          .margin({ top: 16 })
          .enabled(!this.isLoading)
          .onClick(() => {
            this.callAiGeneratePlan()
          })
      }
      .padding({ left: 24, right: 24 })

      Column() {
        Text('📋 结果')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })

        Text(this.statusMessage)
          .fontSize(13)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        Scroll() {
          Text(this.resultJson)
            .fontSize(12)
            .fontFamily('Courier New')
            .fontColor('#1A1A2E')
            .backgroundColor('#F8F9FF')
            .borderRadius(8)
            .padding(12)
            .width('100%')
        }
        .layoutWeight(1)
        .borderRadius(8)
        .backgroundColor('#F8F9FF')
        .width('100%')
      }
      .padding({ left: 24, right: 24 })
      .margin({ top: 16 })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  async callAiGeneratePlan() {
    if (!this.inputText.trim()) {
      this.statusMessage = '⚠️ 请输入任务描述'
      return
    }

    this.isLoading = true
    this.statusMessage = '⏳ 正在调用 AI 生成计划...'
    this.resultJson = ''

    try {
      const client: AGCClient = AGCClient.getInstance()
      const today: string = new Date().toISOString().split('T')[0]
      const response: AIResponse = await client.callGeneratePlan(this.inputText.trim(), today)

      this.resultJson = JSON.stringify(response, null, 2)
      this.statusMessage = `✅ 成功！解析到 ${response.tasks.length} 个任务，${response.schedule.length} 个排程项`
    } catch (error) {
      const err: BusinessError = error as BusinessError
      this.statusMessage = `❌ 调用失败: ${err.message}`
      const errInfo: ErrorInfo = { error: err.message }
      this.resultJson = JSON.stringify(errInfo, null, 2)
    } finally {
      this.isLoading = false
    }
  }
}
