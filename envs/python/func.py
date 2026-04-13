import io
import json
import logging
import oci

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