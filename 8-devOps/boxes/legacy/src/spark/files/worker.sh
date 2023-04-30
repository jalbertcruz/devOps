#!/bin/bash




. "/usr/local/spark/sbin/spark-config.sh"

. "/usr/local/spark/bin/load-spark-env.sh"

#export SPARK_WORKER_LOG=/spark/logs
#export SPARK_WORKER_WEBUI_PORT=8081
#export SPARK_MASTER="spark://spark-master.service.dc1.consul:7077"

mkdir -p "${SPARK_WORKER_LOG}"

ln -sf /dev/stdout "${SPARK_WORKER_LOG}"/spark-worker.out

/usr/local/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port "${SPARK_WORKER_WEBUI_PORT}" "${SPARK_MASTER}" >> "${SPARK_WORKER_LOG}"/spark-worker.out

#mkdir -p "${SPARK_WORKER_LOG}"
#
#ln -sf /dev/stdout "${SPARK_MASTER_LOG}"/spark-master.out
#
#/usr/local/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
#    --webui-port "${SPARK_WORKER_WEBUI_PORT}" "${SPARK_MASTER}" >> "${SPARK_WORKER_LOG}"/spark-worker.out
