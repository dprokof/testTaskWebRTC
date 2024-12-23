import pjsua as pj
import sys
import logging
from kurento import KurentoClient, MediaPipeline, WebRtcEndpoint, RecorderEndpoint

# Логирование
logging.basicConfig(level=logging.DEBUG)

# Настройки SIP
SIP_SERVER = 'sip.example.com'
SIP_USER = 'user1'
SIP_PASSWORD = 'password'
SIP_CALLER = 'sip:user1@sip.example.com'
SIP_CALLEE = 'sip:user2@sip.example.com'

# Настройки Kurento Media Server
KMS_URL = 'ws://localhost:8888/kurento'

# Подключение к Kurento Media Server
kurento_client = KurentoClient(KMS_URL)
pipeline = kurento_client.create(MediaPipeline)
webrtc_endpoint = WebRtcEndpoint(pipeline)
recorder_endpoint = RecorderEndpoint(pipeline, uri='file:///path/to/recorded_audio.wav')

lib = pj.Lib()

try:
    lib.init(log_cfg=pj.LogConfig(level=3, callback=log_cb))
    lib.create_transport(pj.TransportType.UDP, pj.TransportConfig(5060))
    lib.start()

    acc_cfg = pj.AccountConfig(domain=SIP_SERVER, username=SIP_USER, password=SIP_PASSWORD)
    acc = lib.create_account(acc_cfg)

    def on_incoming_call(account, call):
        call.answer(180)  # Ответ на звонок
        print("Звонок принят")
        call.connect()

        webrtc_endpoint = WebRtcEndpoint(pipeline)
        recorder_endpoint.connect(webrtc_endpoint)

        recorder_endpoint.record()

    acc.set_incoming_call_cb(on_incoming_call)

    call = acc.make_call(SIP_CALLEE)

    print("Ожидание завершения звонка...")

except Exception as e:
    print(f"Ошибка: {e}")

finally:
    # Завершаем соединение
    lib.destroy()
    lib = None
