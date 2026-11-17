import { emitter } from '@kit.BasicServicesKit'

export const PlayStateEvent: emitter.InnerEvent = {
  eventId: 1001,
  priority: emitter.EventPriority.IMMEDIATE
  //立即优先级（最高）,其次是high和low
}
