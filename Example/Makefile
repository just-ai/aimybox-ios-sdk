.PHONY: log protos generate clean help

TTS_OUT_PATH := ../Components/YandexSpeechKit/Sources/YandexSynthesisAPI/Generated
STT_OUT_PATH := ../Components/YandexSpeechKit/Sources/YandexRecognitionAPI/Generated

log: help

## protos-google: Pull protos from Google Repository
protos-google:
	rm -rf googleapis/
	curl -L -O https://github.com/googleapis/googleapis/archive/master.zip
	unzip master.zip
	rm -f master.zip
	mv googleapis-master googleapis

## protos-yandex: Pull protos from Yandex Repository
protos-yandex:
	rm -rf yandexapis/
	curl -L -O https://github.com/yandex-cloud/cloudapi/archive/refs/heads/master.zip
	unzip master.zip
	rm -f master.zip
	mv cloudapi-master yandexapis

## generate-tts: Generate tts
generate-tts:
	protoc \
		./tts.proto \
		./tts_service.proto \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=$(TTS_OUT_PATH) \
		--swift_opt=Visibility=Public \
		--swift_out=$(TTS_OUT_PATH) 

## generate-stt: Generate stt
generate-stt:
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

## clear: Generate stt
clear:
	rm -rf Pods/
	rm -rf googleapis/
	rm -rf yandexapis/
	rm $(TTS_OUT_PATH)/*
	rm $(STT_OUT_PATH)/*

## generate: Generate all
generate: | protos-google protos-yandex generate-tts generate-stt

## pod-install: Generate all
pod-install:
	pod install