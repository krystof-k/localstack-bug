require 'aws-sdk-s3'

client_config = {
  region: ENV['AWS_REGION'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  endpoint: ENV['S3_ENDPOINT'],
}.compact

s3_client = Aws::S3::Client.new(client_config)

bucket = Aws::S3::Bucket.new(
  name: ENV['S3_BUCKET'], client: s3_client
)

presigned_post = bucket.presigned_post(
  {
    signature_expiration: Time.now + 60*60*24,
    key: 'room-test-847275547/system/tmp/files/2022/08/03/VCGsmidyZTDJLbMFK5QouZ/${filename}',
    content_length_range: 0..256000,
    metadata: { token: 'eyJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJkbS1zMy11cGxvYWQiLCJzdWIiOiI1MXZ2Smc0Q1hvU1ZYc1BZN2NSZEEyIEVicVJIc2NVSjluYVdKU3pKcjhvR1MiLCJleHAiOjE2NjA3NjY3OTYsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0IiwiaWF0IjoxNjU5NTU3MTk2fQ.pmPVuO57f2Fdx2PLVFN3J1lwwCSPt2ou5Obsf3-hRRCQKLobuRH7xBZtil2-5sHyJ_bLThZLwHoQRmNLcRvxfHH3BCvf_g3_eGYEYYC4UXn7L1XPKc3iVg3sRK658Ghi15t-mIywhV_XXjcOIjpw6KL7OijT6-HoTSmQA0Mj73MRlwz2UQu9bO0i4WuUpykctTtC-DnjhZGlHTsVk5U5hDVQLP9mfMtCj8SWt4Ur5XO75YlmmE1sZuxDBxueT4F-QE5W270NzAi0FGAgl201oSrwIB5woAd6il6CED_vfHo1yE4XBOA5Iog_fEg1G4XQ6qSGGq6T_gpOMnEho-mPgA' },
  }
)

fields = presigned_post.fields.map do | key, value |
  "--form '#{key}=#{value}' \\"
end

curl = "curl --location --request POST '#{presigned_post.url}' " + fields.join("\n")

File.open('curl.txt', 'w') do |f|
  f.puts curl + "\n--form 'file=@\"./test.png\"'" + "\n\n" + curl + "\n--form 'file=@\"./test.txt\"'"
end
