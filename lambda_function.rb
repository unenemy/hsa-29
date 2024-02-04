require 'aws-sdk-s3'
require 'mini_magick'

def lambda_handler(event:, context:)
  s3_client = Aws::S3::Client.new

  event['Records'].each do |record|
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']

    # Download the JPEG file from S3
    jpeg_file_path = "/tmp/#{key}"
    puts "Downloading: #{key} in bucket #{bucket}"
    s3_client.get_object(bucket: bucket, key: key, response_target: jpeg_file_path)
    puts "Download complete.. converting to png.."

    # Convert the JPEG to PNG
    png_file_path = convert_image(jpeg_file_path, 'png')
    puts "Conversion to PNG complete"
    
    upload_file(s3_client, key, png_file_path, 'png')
    puts "PNG uploaded"

    # Convert the JPEG to GIF
    gif_file_path = convert_image(jpeg_file_path, 'gif')
    puts "Conversion to GIF complete"
    
    upload_file(s3_client, key, gif_file_path, 'gif')
    puts "GIF uploaded"

    # Convert the JPEG to BMP
    bmp_file_path = convert_image(jpeg_file_path, 'bmp')
    puts "Conversion to BMP complete"

    upload_file(s3_client, key, bmp_file_path, 'bmp')
    puts "BMP uploaded"
  end
end

def convert_image(input_file, output_format)
  output_file = "/tmp/#{File.basename(input_file, '.*')}.#{output_format}"
  puts "Output formed"

  image = MiniMagick::Image.open(input_file)
  puts "Image opened"
  image.format(output_format)
  puts "Image formatted"
  image.write(output_file)
  puts "Image Written"

  output_file
end

def upload_file(s3_client, original_key, file_path, format)
  new_key = "#{File.basename(original_key, '.*')}_converted.#{format}"
  
  File.open(file_path, 'rb') do |file|
    s3_client.put_object(bucket: 'hsa-29-output', key: new_key, body: file)
  end
end