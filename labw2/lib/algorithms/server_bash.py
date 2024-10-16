from flask import Flask, request, jsonify, send_file
import numpy as np
import cv2
import urllib.request
import io
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def url_to_image(url):
    resp = urllib.request.urlopen(url)
    image = np.asarray(bytearray(resp.read()), dtype="uint8")
    image = cv2.imdecode(image, cv2.IMREAD_COLOR)
    return image

def bernsen_threshold(image, window_size=15, contrast_threshold=15, threshold_value=127):
    half_size = window_size // 2
    thresh_image = np.zeros_like(image)
    for i in range(half_size, image.shape[0] - half_size):
        for j in range(half_size, image.shape[1] - half_size):
            local_region = image[i - half_size:i + half_size + 1, j - half_size:j + half_size + 1]
            local_min = np.min(local_region)
            local_max = np.max(local_region)
            local_contrast = local_max - local_min
            
            mid_value = (local_max + local_min) / 2
            
            if local_contrast < contrast_threshold:
                thresh_image[i, j] = 255 if mid_value > threshold_value else 0
            else:
                thresh_image[i, j] = 255 if image[i, j] > mid_value else 0
                
    return thresh_image

def niblack_threshold(image, window_size=15, k=-0.2, threshold_value=127):
    mean = cv2.boxFilter(image, cv2.CV_32F, (window_size, window_size))
    sqmean = cv2.sqrBoxFilter(image, cv2.CV_32F, (window_size, window_size))
    variance = sqmean - mean ** 2
    stddev = np.sqrt(variance)
    
    thresh_image = np.where(image > (mean + k * stddev + threshold_value), 255, 0)
    return thresh_image.astype(np.uint8)

@app.route('/threshold/bernsen', methods=['POST'])
def apply_bernsen_threshold():
    data = request.json
    image_url = data['url']
    window_size = data.get('window_size', 15)
    contrast_threshold = data.get('contrast_threshold', 15)
    threshold_value = data.get('threshold', 127)

    try:
        image = url_to_image(image_url)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        thresh = bernsen_threshold(gray, window_size, contrast_threshold, threshold_value)
        
        _, buffer = cv2.imencode('.png', thresh)
        image_bytes = io.BytesIO(buffer)

        return send_file(image_bytes, mimetype='image/png')
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/threshold/niblack', methods=['POST'])
def apply_niblack_threshold():
    data = request.json
    image_url = data['url']
    window_size = data.get('window_size', 15)
    k = data.get('k', -0.2)
    threshold_value = data.get('threshold', 127)
    
    try:
        image = url_to_image(image_url)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        thresh = niblack_threshold(gray, window_size=window_size, k=k, threshold_value=threshold_value)
        
        _, buffer = cv2.imencode('.png', thresh)
        image_bytes = io.BytesIO(buffer)

        return send_file(image_bytes, mimetype='image/png')
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/threshold/global', methods=['POST'])
def apply_global_threshold():
    data = request.json
    print(f"Received data for Global thresholding: {data}")
    image_url = data['url']
    threshold_value = data.get('threshold', 127)
    max_value = data.get('max_value', 255)

    try:
        image = url_to_image(image_url)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        _, thresh = cv2.threshold(gray, threshold_value, max_value, cv2.THRESH_BINARY)

        _, buffer = cv2.imencode('.png', thresh)
        image_bytes = io.BytesIO(buffer)

        print(f"Processed Global thresholding for URL: {image_url}")
        return send_file(image_bytes, mimetype='image/png')
    except Exception as e:
        print(f"Error processing Global threshold: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/threshold/statistical', methods=['POST'])
def apply_statistical_filter():
    data = request.json
    image_url = data['url']
    window_size = data.get('window_size', 3)

    try:
        image = url_to_image(image_url)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

        half_size = window_size // 2
        filtered_image = np.zeros_like(gray)

        for i in range(half_size, gray.shape[0] - half_size):
            for j in range(half_size, gray.shape[1] - half_size):
                local_region = gray[i - half_size:i + half_size + 1, j - half_size:j + half_size + 1]
                filtered_image[i, j] = np.median(local_region)

        _, buffer = cv2.imencode('.png', filtered_image)
        image_bytes = io.BytesIO(buffer)

        return send_file(image_bytes, mimetype='image/png')
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, use_reloader=False, host='0.0.0.0')
