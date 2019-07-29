echo 'Inside';
pwd;

echo "---> Model location: /opt/app-root/src/output/mnist_saved_model/1/"
ls -la /opt/app-root/src/output/mnist_saved_model/1/

ls -la /opt/app-root/src/tensorflowapp-sample/
ls -la /opt/app-root/src/input/test/
python /opt/app-root/src/tensorflowapp-sample/tensorflowapp-inference.py --prefix mnist- --inference_path /opt/app-root/src/input/test/test.png --saved_model_name my_saved_model /opt/app-root/src/output /opt/app-root/src/output