// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_webhook_signature_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyWebhookSignatureRequest _$VerifyWebhookSignatureRequestFromJson(
        Map<String, dynamic> json) =>
    VerifyWebhookSignatureRequest(
      authAlgo: json['auth_algo'] as String,
      certUrl: json['cert_url'] as String,
      transmissionId: json['transmission_id'] as String,
      transmissionSig: json['transmission_sig'] as String,
      transmissionTime: json['transmission_time'] as String,
      webhookId: json['webhook_id'] as String,
      webhookEvent: json['webhook_event'] as String,
    );

Map<String, dynamic> _$VerifyWebhookSignatureRequestToJson(
        VerifyWebhookSignatureRequest instance) =>
    <String, dynamic>{
      'auth_algo': instance.authAlgo,
      'cert_url': instance.certUrl,
      'transmission_id': instance.transmissionId,
      'transmission_sig': instance.transmissionSig,
      'transmission_time': instance.transmissionTime,
      'webhook_id': instance.webhookId,
      'webhook_event': instance.webhookEvent,
    };
