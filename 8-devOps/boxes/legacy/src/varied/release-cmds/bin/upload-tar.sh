#!/usr/bin/env bash

FILENAME="payment_services-centos7.tar"
tar -cf _build/prod/rel/${FILENAME} -C _build/prod/rel payment_services
RELEASES_BUCKET=sb-payments-releases
aws s3api put-object --bucket ${RELEASES_BUCKET} --key ${FILENAME} --body _build/prod/rel/${FILENAME}
