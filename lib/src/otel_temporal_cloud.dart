// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_temporal_cloud_suppression.dart';

class TemporalCloudResult {
  const TemporalCloudResult({
    this.account,
    this.namespace,
    this.namespaceState,
    this.region,
    this.cloudProvider,
    this.taskQueue,
    this.workflowId,
    this.workflowRunId,
    this.workflowType,
    this.workflowStatus,
    this.workflowAttempt,
    this.activityType,
    this.activityId,
    this.activityAttempt,
    this.activityStatus,
    this.signalName,
    this.queryName,
    this.workerIdentity,
    this.actionsCount,
    this.actionsPerSecond,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? account;
  final String? namespace;
  final String? namespaceState;
  final String? region;
  final String? cloudProvider;
  final String? taskQueue;
  final String? workflowId;
  final String? workflowRunId;
  final String? workflowType;
  final String? workflowStatus;
  final int? workflowAttempt;
  final String? activityType;
  final String? activityId;
  final int? activityAttempt;
  final String? activityStatus;
  final String? signalName;
  final String? queryName;
  final String? workerIdentity;
  final int? actionsCount;
  final int? actionsPerSecond;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class TemporalCloudCallResult<T> {
  const TemporalCloudCallResult({required this.value, this.result});
  final T value;
  final TemporalCloudResult? result;
}

Future<T> tracedTemporalCloud<T>({
  required String operation,
  required Future<TemporalCloudCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (temporalCloudInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_temporal_cloud');
  final span = t.startSpan('temporal $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'temporal')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.account != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.account', res.account!)]));
      }
      if (res.namespace != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.namespace', res.namespace!)]));
      }
      if (res.namespaceState != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.namespace.state', res.namespaceState!)
        ]));
      }
      if (res.region != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.region', res.region!)]));
      }
      if (res.cloudProvider != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.cloud_provider', res.cloudProvider!)
        ]));
      }
      if (res.taskQueue != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.task_queue', res.taskQueue!)]));
      }
      if (res.workflowId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.workflow.id', res.workflowId!)]));
      }
      if (res.workflowRunId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.workflow.run_id', res.workflowRunId!)
        ]));
      }
      if (res.workflowType != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.workflow.type', res.workflowType!)
        ]));
      }
      if (res.workflowStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.workflow.status', res.workflowStatus!)
        ]));
      }
      if (res.workflowAttempt != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('temporal.workflow.attempt', res.workflowAttempt!)
        ]));
      }
      if (res.activityType != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.activity.type', res.activityType!)
        ]));
      }
      if (res.activityId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.activity.id', res.activityId!)]));
      }
      if (res.activityAttempt != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('temporal.activity.attempt', res.activityAttempt!)
        ]));
      }
      if (res.activityStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.activity.status', res.activityStatus!)
        ]));
      }
      if (res.signalName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.signal.name', res.signalName!)]));
      }
      if (res.queryName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.query.name', res.queryName!)]));
      }
      if (res.workerIdentity != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('temporal.worker.identity', res.workerIdentity!)
        ]));
      }
      if (res.actionsCount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('temporal.actions.count', res.actionsCount!)]));
      }
      if (res.actionsPerSecond != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt(
              'temporal.actions_per_second', res.actionsPerSecond!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('temporal.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.workflowStatus == 'Failed' ||
          res.workflowStatus == 'Terminated' ||
          res.workflowStatus == 'TimedOut' ||
          res.activityStatus == 'Failed' ||
          res.activityStatus == 'TimedOut';
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'temporal.error')
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
