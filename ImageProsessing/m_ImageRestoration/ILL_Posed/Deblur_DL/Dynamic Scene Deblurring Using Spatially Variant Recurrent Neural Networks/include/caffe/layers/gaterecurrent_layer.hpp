#ifndef GATE_RECURRENT_LAYER_HPP_
#define GATE_RECURRENT_LAYER_HPP_

#include <string>
#include <utility>
#include <vector>

#include "caffe/blob.hpp"
#include "caffe/common.hpp"
// #include "caffe/common_layers.hpp"
#include "caffe/layers/data_layer.hpp"
#include "caffe/layer.hpp"
#include "caffe/layers/loss_layer.hpp"
#include "caffe/layers/neuron_layer.hpp"
#include "caffe/proto/caffe.pb.h"

namespace caffe {

template <typename Dtype>
class GateRecurrentLayer : public Layer<Dtype> {/// Gate Recurrent Layer, add by liangji, 20150905
public:
  explicit GateRecurrentLayer(const LayerParameter& param)
      : Layer<Dtype>(param) {}
  virtual void LayerSetUp(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);
  virtual void Reshape(const vector<Blob<Dtype>*>& bottom,
      const vector<Blob<Dtype>*>& top);

  virtual inline const char* type() const { return "GateRecurrent"; }
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
  
  void disorder_inputdata(const Dtype * datain, Dtype * dataout, bool horizontal, bool reverse, int channels);
  void reorder_outputdata(const Dtype * datain, Dtype * dataout, bool horizontal, bool reverse, int channels);
  void disorder_gpu_inputdata(const Dtype * datain, Dtype * dataout, bool horizontal, bool reverse, int channels);
  void reorder_gpu_outputdata(const Dtype * datain, Dtype * dataout, bool horizontal, bool reverse, int channels);
  
  void active_Forward_cpu(const int n, Dtype * data);
  void active_Backward_cpu(const int n, const Dtype * data, Dtype * diff);
  
  void active_Forward_gpu(const int n, Dtype * data);
  void active_Backward_gpu(const int n, const Dtype * data, Dtype * diff);
  
  int num_output_;
  int height_out_, width_out_;
  bool bias_term_;
  int num_;
  int channels_;
  int height_, width_;
  int M_;
  int K_x_;
  int K_h_;
  int N_;
  int T_;
  int col_count_;
  int col_length_;
  Blob<Dtype> col_buffer_;
  Blob<Dtype> bias_multiplier_;
  Blob<Dtype> x_disorder_buffer_;
  Blob<Dtype> h_disorder_buffer_;
  Blob<Dtype> gate_disorder_buffer_;
  Blob<Dtype> L_data_buffer_;
  
  bool gate_control_;
  bool horizontal_;
  bool reverse_;
  bool use_bias_;
  bool use_wx_;
  bool use_wh_;
  
  Dtype bound_diff_threshold_;
  float restrict_w_;
  Dtype restrict_g_;
};

}  // namespace caffe

#endif  // GATE_RECURRENT_LAYER_HPP_
