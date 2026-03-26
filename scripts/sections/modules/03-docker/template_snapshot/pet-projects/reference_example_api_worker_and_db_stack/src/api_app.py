import os

from flask import Flask, jsonify, request

from config_loader import load_config
from db import ensure_tables, get_connection, insert_job
from processor import validate_job


app = Flask(__name__)
CONFIG_PATH = os.getenv("APP_CONFIG_PATH", "config/app_config.json")


@app.route("/health", methods=["GET"])
def health() -> tuple:
    return jsonify({"status": "ok"}), 200


@app.route("/jobs", methods=["POST"])
def create_job() -> tuple:
    config = load_config(CONFIG_PATH)
    job = request.get_json(force=True)
    validate_job(job, config["valid_job_types"])

    connection = get_connection()
    try:
        ensure_tables(connection, config["job_table"], config["result_table"])
        insert_job(connection, config["job_table"], job)
    finally:
        connection.close()

    return jsonify({"job_id": job["job_id"], "status": "pending"}), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("API_PORT", "8000")))