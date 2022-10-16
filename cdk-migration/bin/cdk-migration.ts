#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { CdkMigrationStack } from '../lib/cdk-migration-stack';

const app = new cdk.App();
new CdkMigrationStack(app, 'WordpressBlog', {
  env: {account: '835451110523', region: 'us-east-1'},
});