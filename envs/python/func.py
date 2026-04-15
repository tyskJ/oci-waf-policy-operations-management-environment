import io
import json
import logging
import oci
from datetime import datetime, timezone

from fdk import response

"""
EntryPoint
"""
def handler(ctx, data: io.BytesIO = None):
    logger = logging.getLogger()
    logger.info("LogAnalytics Storage Purge Started")
    # ----- 1. Resource Principal Signer -----
    try:
        signer = oci.auth.signers.get_resource_principals_signer()
        logger.info("Resource Principal Signer acquired successfully")
    except Exception as e:
        logger.error(f"Failed to get Resource Principal Signer: {e}")
        return error_response(ctx, str(e), 500)
    # ----- 2. Log Analytics Client -----
    try:
        log_analytics_client = oci.log_analytics.LogAnalyticsClient(
            config={},
            signer=signer
        )
        logger.info("LogAnalyticsClient initialized")
    except Exception as e:
        logger.error(f"Failed to initialize LogAnalyticsClient: {e}")
        return error_response(ctx, str(e), 500)
    # ----- 3. Purge 実行 -----
    try:
        tenancy_id = signer.tenancy_id
        os_client = oci.object_storage.ObjectStorageClient(
            config={},
            signer=signer
        )
        namespace = os_client.get_namespace().data
        time = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%MZ')
        purge_details = oci.log_analytics.models.PurgeStorageDataDetails(
           compartment_id=tenancy_id,
           compartment_id_in_subtree=True,
           data_type="LOG",
           purge_query_string="'Log Source' = 'OCI WAF Logs'",
           time_data_ended=time
        )
        resp = log_analytics_client.purge_storage_data(
            namespace_name=namespace,
            purge_storage_data_details=purge_details
        )
        work_request_id = resp.headers.get("opc-work-request-id")
        logger.info(
            "LogAnalytics purge request submitted. "
            f"log_source=OCI WAF Logs, workRequestId={work_request_id}"
        )
        return success_response(
            ctx,
            {
                "message": "LogAnalytics purge request submitted",
                "log_source": "OCI WAF Logs",
                "work_request_id": work_request_id
            },
            202
        )
    except oci.exceptions.ServiceError as e:
        logger.error(
            "Purge failed: "
            f"status={e.status}, code={e.code}, message={e.message}"
        )
        return error_response(ctx, e.message, e.status)
    except Exception as e:
        logger.error(f"Unexpected error during purge: {e}")
        return error_response(ctx, str(e), 500)

"""
Common Func
"""
def success_response(ctx, data: dict, status_code: int=200):
    """成功レスポンスを返す"""
    return response.Response(
        ctx,
        response_data=json.dumps(
            data, 
            ensure_ascii=False, 
            indent=2
        ),
        headers={"Content-Type": "application/json"},
        status_code=status_code
    )

def error_response(ctx, error_message: str, status_code: int=500):
    """エラーレスポンスを返す"""
    return response.Response(
        ctx,
        response_data=json.dumps(
            {"error": error_message}, 
            ensure_ascii=False
        ),
        headers={"Content-Type": "application/json"},
        status_code=status_code
    )