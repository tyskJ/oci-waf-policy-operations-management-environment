Functions デプロイ
=====================================================================
.. note::

  * ``CloudShell (Public Network)`` にて実行します
  * CPU アーキテクチャは ``x86_64`` に変更してください (本環境のfunctions application を ``x86_64`` でデプロイしているため)

1. ``context`` アップデート
---------------------------------------------------------------------
1-1. ``functions region`` アップデート
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

  fn use context ap-tokyo-1

1-2. ``functions compartment ID`` アップデート
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

  COMPARTMENT_NAME="oci-waf-policy-operations-management-environment"
  COMPARTMENT_ID=$(oci iam compartment list \
    --lifecycle-state ACTIVE \
    --query "data[?name=='${COMPARTMENT_NAME}'].id | [0]" \
    --raw-output)

.. code-block:: bash

  fn update context oracle.compartment-id "${COMPARTMENT_ID}"

1-3. ``functions image deploy repository`` アップデート
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block:: bash

  TENANCY_ID=$(oci iam compartment list \
    --lifecycle-state ACTIVE \
    --include-root \
    --query "data[?\"compartment-id\"==null].id | [0]" \
    --raw-output)

.. code-block:: bash

  NAMESPACE=$(oci os ns get \
    --compartment-id "${TENANCY_ID}" \
    --query "data" \
    --raw-output)

.. code-block:: bash

  REPO_PREFIX="management"
  fn update context registry nrt.ocir.io/${NAMESPACE}/${REPO_PREFIX}

2. ``OCIR`` へログイン
---------------------------------------------------------------------
.. note::

  * ``WORK_USERNAME`` の値は、デプロイ時に指定したユーザー名に変更して実行してください
  * ``AUTH_TOKEN`` の値は ``envs/.key/work_user_auth_token.txt`` に記載の値に変更して実行してください

.. code-block:: bash

  TENANCY_ID=$(oci iam compartment list \
    --lifecycle-state ACTIVE \
    --include-root \
    --query "data[?\"compartment-id\"==null].id | [0]" \
    --raw-output)

.. code-block:: bash

  NAMESPACE=$(oci os ns get \
    --compartment-id "${TENANCY_ID}" \
    --query "data" \
    --raw-output)

.. code-block:: bash

  WORK_USERNAME="作業IAMユーザー名"
  AUTH_TOKEN="認証トークン"
  docker login -u "${NAMESPACE}/${WORK_USERNAME}" nrt.ocir.io -p "${AUTH_TOKEN}"

3. 関数の作成
---------------------------------------------------------------------
3-1. 関数初期化
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
.. code-block::

  FN_NAME="purge-storage"
  fn init --runtime python ${FN_NAME}

3-2. コード修正
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ``~/purge-storage/func.py`` の中身を `purge-storage.py <./envs/python/purge-storage.py>`_ に置き換えてください

4. 関数のデプロイ
---------------------------------------------------------------------
.. code-block:: bash

  cd ~/purge-storage
  fn -v deploy --app management-app