// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_temporal_cloud/otel_temporal_cloud.dart';

/// Traces Temporal Cloud calls with OpenTelemetry.
///
/// `otel_temporal_cloud` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Temporal Cloud call in
/// [tracedTemporalCloud]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'temporal-cloud-example');

  // Traces a Temporal Cloud call.
  final temporalCloudId = await tracedTemporalCloud<String>(
    operation: 'create',
    invoke: () async {
      // Make the Temporal Cloud call here, then report what it returned.
      const id = 'temporal_cloud_8f3a2c';
      return const TemporalCloudCallResult(
          value: id,
          result: TemporalCloudResult(
              account: 'example',
              namespace: 'example',
              namespaceState: 'active',
              region: 'us-east-1',
              cloudProvider: 'example',
              taskQueue: 'orders',
              workflowId: 'workflow_8f3a2c',
              workflowRunId: 'workflowrun_8f3a2c',
              workflowType: 'standard',
              workflowStatus: 'succeeded',
              workflowAttempt: 1,
              activityType: 'standard',
              activityId: 'activity_8f3a2c',
              activityAttempt: 1,
              activityStatus: 'succeeded',
              signalName: 'example',
              queryName: 'example',
              workerIdentity: 'example',
              actionsCount: 3,
              actionsPerSecond: 1,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedTemporalCloud create returned $temporalCloudId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutTemporalCloudInstrumentationAsync.
  await runWithoutTemporalCloudInstrumentationAsync(
    () => tracedTemporalCloud<String>(
      operation: 'create',
      invoke: () async {
        const id = 'temporal_cloud_8f3a2c';
        return const TemporalCloudCallResult(
            value: id,
            result: TemporalCloudResult(
                account: 'example',
                namespace: 'example',
                namespaceState: 'active',
                region: 'us-east-1',
                cloudProvider: 'example',
                taskQueue: 'orders',
                workflowId: 'workflow_8f3a2c',
                workflowRunId: 'workflowrun_8f3a2c',
                workflowType: 'standard',
                workflowStatus: 'succeeded',
                workflowAttempt: 1,
                activityType: 'standard',
                activityId: 'activity_8f3a2c',
                activityAttempt: 1,
                activityStatus: 'succeeded',
                signalName: 'example',
                queryName: 'example',
                workerIdentity: 'example',
                actionsCount: 3,
                actionsPerSecond: 1,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
