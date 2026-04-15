# フォルダ構成

- フォルダ構成は以下の通り

```
.
├── deploy_functions.rst              コードデプロイ手順
├── deploy_wafops.rst                 WAF用ダッシュボードデプロイ手順
└── envs
    ├── backend.tf                    tfstateファイル管理定義ファイル
    ├── bastion.tf                    Bastion定義ファイル
    ├── compartments.tf               デプロイ用コンパートメント定義ファイル
    ├── compute_linux.tf              OCI compute(Oracle Linux)定義ファイル
    ├── connector_hub.tf              Connector Hub定義ファイル
    ├── container_registry.tf         Container Registry定義ファイル
    ├── data.tf                       外部データソース定義ファイル
    ├── elb.tf                        FLB定義ファイル
    ├── functions.tf                  Functions定義ファイル
    ├── iam.tf                        IAM定義ファイル
    ├── locals.tf                     ローカル変数定義ファイル
    ├── log_analytics.tf              Log Analytics定義ファイル
    ├── logging.tf                    Logging定義ファイル
    ├── notifications.tf              Notifications定義ファイル
    ├── outputs.tf                    リソース戻り値定義ファイル
    ├── providers.tf                  プロバイダー定義ファイル
    ├── python
    │   ├── func.py                   コード
    │   ├── func.yaml                 Functionsデプロイ設定ファイル
    │   └── requirements.txt          Pythonパッケージリスト
    ├── tags.tf                       デフォルトタグ定義ファイル
    ├── userdata
    │   └── oraclelinux_init.sh       Linux用userdataスクリプト
    ├── variables.tf                  変数定義ファイル
    ├── vcn.tf                        VCN定義ファイル
    ├── versions.tf                   Terraformバージョン定義ファイル
    └── waf.tf                        WAFポリシー定義ファイル
```
