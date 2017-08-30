# coding: utf-8

require_relative "service"

module OrcaApi
  # 診療科コードを扱うサービスを表現したクラス
  class DepartmentService < Service
    # 診療科コード一覧の取得
    def list(base_date = "")
      api_path = "/api01rv2/system01lstv2"
      req_name = "system01_managereq"

      body = {
        req_name => {
          "Request_Number" => "01",
          "Base_Date" => base_date,
        }
      }
      Result.new(orca_api.call(api_path, body: body))
    end
  end
end
