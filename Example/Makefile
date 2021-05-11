.PHONY: log protos generate clean help

TTS_OUT_PATH := ../Components/YandexSpeechKit/Sources/YandexSynthesisAPI/Generated
STT_OUT_PATH := ../Components/YandexSpeechKit/Sources/YandexRecognitionAPI/Generated

log: help

## protosG: Pull protos from Google Repository
protosGoogle:
	curl -L -O https://github.com/googleapis/googleapis/archive/master.zip
	unzip master.zip
	rm -f master.zip
	mv googleapis-master googleapis

## protosY: Pull protos from Yandex Repository
protosYandex:
	curl -L -O https://github.com/yandex-cloud/cloudapi/archive/refs/heads/master.zip
	unzip master.zip
	rm -f master.zip
	mv cloudapi-master yandexapis

## generate: Generate tts
generate_tts:
	protoc \
		./tts.proto \
		./tts_service.proto \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=$(TTS_OUT_PATH) \
		--swift_opt=Visibility=Public,Server=true \
		--swift_out=$(TTS_OUT_PATH) 

## generate: Generate stt
generate_stt:
	protoc \
 		./googleapis/google/api/http.proto \
    	./googleapis/google/rpc/status.proto \
    	./yandexapis/yandex/cloud/operation/operation.proto \
    	./yandexapis/yandex/cloud/ai/stt/v2/stt_service.proto \
    	-I ./yandexapis \
    	-I ./googleapis \
		--grpc-swift_opt=Visibility=Public\
		--grpc-swift_out=$(STT_OUT_PATH) \
		--swift_opt=Visibility=Public \
    	--swift_out=$(STT_OUT_PATH)
	
## generate: Generate all
generate_all: | protosGoogle protosYandex generate_tts generate_stt