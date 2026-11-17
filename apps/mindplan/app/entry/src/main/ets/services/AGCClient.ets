import { cloudFunction } from '@kit.CloudFoundationKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { AIResponse } from '../model/AIResponse'
import {
  CloudFunctionResult,
  HuaweiLoginResult,
  UserPreferencesData,
  GeneratePlanBody,
  HuaweiLoginBody,
  RawApiResponse,
  MappedPlanResult,
  mapApiResponse
} from '../model/AGCResponse'

interface FunctionNameMap {
  generatePlan: string
  huaweiLogin: string
}

const FUNCTION_NAME: FunctionNameMap = {
  generatePlan: 'generate-plan',
  huaweiLogin: 'huawei-login'
}

export class AGCClient {
  private static instance: AGCClient

  static getInstance(): AGCClient {
    if (!AGCClient.instance) {
      AGCClient.instance = new AGCClient()
    }
    return AGCClient.instance
  }

  async callGeneratePlan(input: string, date: string): Promise<AIResponse> {
    const userPrefs: UserPreferencesData = {
      work_start: '09:00',
      work_end: '18:00'
    }
    const body: GeneratePlanBody = {
      input: input,
      date: date,
      user_preferences: userPrefs
    }
    try {
      const raw: cloudFunction.FunctionResult = await cloudFunction.call({
        name: FUNCTION_NAME.generatePlan,
        version: '$latest',
        timeout: 30000,
        data: {
          body: body
        }
      })
      const result: CloudFunctionResult = raw.result as CloudFunctionResult
      if (result.code !== 0) {
        throw new Error(`Cloud function error: ${result.message}`)
      }
      const rawData: RawApiResponse = result.data as RawApiResponse
      const mapped: MappedPlanResult = mapApiResponse(rawData, date)
      return new AIResponse({
        tasks: mapped.tasks,
        schedule: mapped.schedule,
        motivation: mapped.motivation
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError
      console.error(`AGCClient.callGeneratePlan failed:`, err.message)
      throw new Error(err.message)
    }
  }

  async callHuaweiLogin(authorizationCode: string): Promise<HuaweiLoginResult> {
    const body: HuaweiLoginBody = {
      authorizationCode: authorizationCode
    }
    try {
      const raw: cloudFunction.FunctionResult = await cloudFunction.call({
        name: FUNCTION_NAME.huaweiLogin,
        version: '$latest',
        timeout: 10000,
        data: {
          body: body
        }
      })
      const result: CloudFunctionResult = raw.result as CloudFunctionResult
      if (result.code !== 0) {
        throw new Error(`Cloud function error: ${result.message}`)
      }
      const loginData: HuaweiLoginResult = result.data as HuaweiLoginResult
      return loginData
    } catch (error) {
      const err: BusinessError = error as BusinessError
      console.error(`AGCClient.callHuaweiLogin failed:`, err.message)
      throw new Error(err.message)
    }
  }
}
