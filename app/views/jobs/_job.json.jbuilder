json.extract! job, :id, :body, :status, :created_at, :updated_at
json.url job_url(job, format: :json)
