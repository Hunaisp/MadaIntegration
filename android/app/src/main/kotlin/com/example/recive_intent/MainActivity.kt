package com.example.recive_intent

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
class Consts {
    companion object {
        /**
         * payment application package name
         */
        const val PACKAGE = "com.intersoft.acquire.mada"

        /**
         * service  action
         */
        const val SERVICE_ACTION = "android.intent.action.intersoft.PAYMENT.SERVICE"

        /** bank aquire ，action */
        const val CARD_ACTION = "android.intent.action.intersoft.PAYMENT"


        /** union pay scan ，action */
        const val UNIONPAY_ACTION = "android.intent.action.intersoft.PAYMENT_UNION_SCAN"

        /**
         * installment
         */
        const val INSTALLMENT_ACTION = "android.intent.action.intersoft.PAYMENT_INSTALLMENT"
    }
}

class ThirdTag {

    companion object {
        val CHANNEL_ID = "channelId"

        val TRANS_TYPE = "transType"

        val AMOUNT = "amount"

        val OUT_ORDERNO = "outOrderNo"

        val IS_OPEN_ADMIN = "isOpenAdminVerify"

        val JSON_DATA = "JSON_DATA"

        //CR# 15.09.2021
        val XML_DATA = "XML_DATA"

        //========================
        val AC_TXN_OUT_OF_ORDER = 8005 /*XML sale with OrderId format result  */
        val AC_TERMINAL_INFO = 8007 /*XML Terminal Info format result  */
        val TRANSACTION_RECONCILIATION = 8003 /*XML RECONCILIATION format result  */
        val TRANSACTION_REVERSAL = 8006 /*XML voidsale format result  */
        val TRANSACTION_Refund = 8008 /*XML Refund format result  */
        val LAST_TRANSACTION = 8001 /*XML Last Transacion format result  */
        val LAST_RECONCILIATION = 8002 /*XML Last Reconciliation format result  */
        val Sale_TRANSACTION = 8004 /*XML Sale format result  */
        const val AC_TXN_OUT_OF_ORDER_JSON = 28005 /*JSon sale with OrderId format result  */
        const val AC_TERMINAL_INFO_JSON = 28007 /*JSon Terminal Info format result  */
        const val TRANSACTION_RECONCILIATION_JOSON = 28003 /*JSon sale format result  */
        const val TRANSACTION_REVERSAL_JOSON = 28006 /*JSon voidsale format result  */
        const val TRANSACTION_Refund_JSON = 28008 /*Json Refund format result  */
        const val LAST_TRANSACTION_JOSON = 28001 /*Json Last Transacion format result  */
        const val LAST_RECONCILIATION_JOSON = 28002 /*XML Last Reconciliation format result  */
        const val Sale_TRANSACTION_JOSON = 28004 /*XML Sale format result  */
        const val PRINT = 9000

        var passingType = 0
        var AC_OUT_ORDERNO = ""
        var title = ""
    }

}
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example/callme"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "callme") {
                    val arg = call.arguments as? Map<String, Any>
                    val outOrderNo = arg?.get("outOrderNo") as? String
                    val amount = arg?.get("amount") as? String
                    val isJSONOption = arg?.get("isJSONOption") as? Boolean ?: false // Assuming isJSONOption is passed from Flutter

                    if (outOrderNo != null && amount != null) {
                        val intent = Intent()
                        intent.setPackage(Consts.PACKAGE)
                        intent.setAction(Consts.CARD_ACTION)
                        intent.putExtra(ThirdTag.CHANNEL_ID, "acquire")

                        if (isJSONOption) {
                            intent.putExtra(ThirdTag.TRANS_TYPE, ThirdTag.Sale_TRANSACTION_JOSON)
                        } else {
                            intent.putExtra(ThirdTag.TRANS_TYPE, ThirdTag.Sale_TRANSACTION)
                        }

                        intent.putExtra(ThirdTag.OUT_ORDERNO, outOrderNo)
                        intent.putExtra(ThirdTag.AMOUNT, amount.toLong())

                        startActivityForResult(intent, 12)
                        result.success("Message received by Kotlin")
                    } else {
                        result.error("ARGUMENT_ERROR", "Argument type mismatch or missing data", null)
                    }
                } else {
                    result.notImplemented()
                }
            }


    }
}

