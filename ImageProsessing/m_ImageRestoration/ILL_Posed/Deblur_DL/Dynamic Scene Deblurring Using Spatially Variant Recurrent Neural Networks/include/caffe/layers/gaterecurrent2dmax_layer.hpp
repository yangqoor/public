/*
*/
#ifndef CAFFE_GATERECURRENT2DMAX_LAYER_HPP_
#define CAFFE_GATERECURRENT2DMAX_LAYER_HPP_

#include <vector>

#include "caffe/blob.hpp"
#include "caffe/layer.hpp"
#include "caffe/proto/caffe.pb.h"

namespace caffe {

template <typename Dtype>
class GateRecurrent2dmaxLayer : public Layer<Dtype> {// 2d rnn with max-pooled gates, by Sifei Liu
public:
  explicit GateRecurrent2dmaxLayer(const LayerParameter& param)
      : Layer<Dtype>(param) {}
  virtual void LayerSetUp(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);
  virtual void Reshape(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);

  virtual inline const char* type() const { return "GateRecurrent2dmax"; }
  virtual inline int ExactNumTopBlobs() const { return 1; }

 protected:
  virtual void Forward_cpu(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);
  virtual void Backward_cpu(const vector<Blob<Dtype>*>& top,
      const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom);
  virtual void Forward_gpu(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);
  virtual void Backward_gpu(const vector<Blob<Dtype>*>& top,
      const vector<bool>& propagate_down, const vector<Blob<Dtype>*>& bottom);
  
  Blob<Dtype> H_;
  
  int num_;
  int height_;
  int width_;
  int channels_;
  bool horizontal_;
  bool reverse_;
  bool maxidpool_;

};


}  // namespace caffe

#endif  // CAFFE_GATERECURRENT2DNOIND_LAYER_HPP_
