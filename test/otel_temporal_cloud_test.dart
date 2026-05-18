// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_temporal_cloud/otel_temporal_cloud.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_temporal_cloud-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('workflow.start records type + task queue', () async {
    await tracedTemporalCloud<String>(
      operation: 'workflow.start',
      invoke: () async => const TemporalCloudCallResult(
        value: 'ok',
        result: TemporalCloudResult(
          namespace: 'prod.dartastic',
          region: 'us-west-2',
          cloudProvider: 'aws',
          taskQueue: 'orders',
          workflowId: 'order-123',
          workflowType: 'ProcessOrder',
          workflowStatus: 'Running',
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('temporal workflow.start')!);
    expect(a['temporal.task_queue'], 'orders');
    expect(a['temporal.workflow.type'], 'ProcessOrder');
  });

  test('Failed workflow sets span error', () async {
    await tracedTemporalCloud<String>(
      operation: 'workflow.describe',
      invoke: () async => const TemporalCloudCallResult(
        value: 'ok',
        result: TemporalCloudResult(
          workflowId: 'order-123',
          workflowStatus: 'Failed',
          workflowAttempt: 3,
        ),
      ),
    );
    expect(
      spans.findSpanByName('temporal workflow.describe')!.status,
      SpanStatusCode.Error,
    );
  });

  test('TimedOut activity sets span error', () async {
    await tracedTemporalCloud<String>(
      operation: 'activity.complete',
      invoke: () async => const TemporalCloudCallResult(
        value: 'ok',
        result: TemporalCloudResult(
          activityType: 'ChargeCard',
          activityStatus: 'TimedOut',
          activityAttempt: 5,
        ),
      ),
    );
    expect(
      spans.findSpanByName('temporal activity.complete')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutTemporalCloudInstrumentationAsync(() async {
      await tracedTemporalCloud<String>(
        operation: 'namespaces.list',
        invoke: () async => const TemporalCloudCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('temporal '), isEmpty);
  });
}
