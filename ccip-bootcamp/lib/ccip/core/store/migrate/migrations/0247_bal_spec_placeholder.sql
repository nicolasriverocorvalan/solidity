-- +goose Up
CREATE TABLE bal_specs (
  id BIGSERIAL PRIMARY KEY
);
ALTER TABLE
  jobs
ADD
  COLUMN bal_spec_id INT REFERENCES bal_specs (id),
DROP
  CONSTRAINT chk_specs,
ADD
  CONSTRAINT chk_specs CHECK (
    num_nonnulls(
      ocr_oracle_spec_id, ocr2_oracle_spec_id,
      direct_request_spec_id, flux_monitor_spec_id,
      keeper_spec_id, cron_spec_id, webhook_spec_id,
      vrf_spec_id, blockhash_store_spec_id,
      block_header_feeder_spec_id, bootstrap_spec_id,
      gateway_spec_id,
      legacy_gas_station_server_spec_id,
      legacy_gas_station_sidecar_spec_id,
      eal_spec_id,
      workflow_spec_id,
      standard_capabilities_spec_id,
      ccip_spec_id,
      ccip_bootstrap_spec_id,
      bal_spec_id,
      CASE "type" WHEN 'stream' THEN 1 ELSE NULL END -- 'stream' type lacks a spec but should not cause validation to fail
    ) = 1
  );

-- +goose Down
ALTER TABLE
  jobs
DROP
  CONSTRAINT chk_specs,
ADD
  CONSTRAINT chk_specs CHECK (
    num_nonnulls(
      ocr_oracle_spec_id, ocr2_oracle_spec_id,
      direct_request_spec_id, flux_monitor_spec_id,
      keeper_spec_id, cron_spec_id, webhook_spec_id,
      vrf_spec_id, blockhash_store_spec_id,
      block_header_feeder_spec_id, bootstrap_spec_id,
      gateway_spec_id,
      legacy_gas_station_server_spec_id,
      legacy_gas_station_sidecar_spec_id,
      eal_spec_id,
      workflow_spec_id,
      standard_capabilities_spec_id,
      ccip_spec_id,
      ccip_bootstrap_spec_id,
      CASE "type" WHEN 'stream' THEN 1 ELSE NULL END -- 'stream' type lacks a spec but should not cause validation to fail
    ) = 1
  );
ALTER TABLE
  jobs
DROP
  COLUMN bal_spec_id;
DROP
  TABLE IF EXISTS bal_specs;