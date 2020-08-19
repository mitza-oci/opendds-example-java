import DDS.*;
import OpenDDS.DCPS.*;
import Example.*;

public class ExampleListener extends DDS._DataReaderListenerLocalBase {

  public void on_data_available(DataReader reader) {
    MessageDataReader mdr = MessageDataReaderHelper.narrow(reader);
    if (mdr == null) {
      System.err.println("ERROR: on_data_available: narrow failed.");
      return;
    }

    MessageHolder mh = new MessageHolder(new Message(""));
    SampleInfoHolder sih = new SampleInfoHolder(new SampleInfo());
    sih.value.source_timestamp = new DDS.Time_t();

    while (true) {
      int status = mdr.take_next_sample(mh, sih);
      if (status == RETCODE_OK.value) {
        if (sih.value.valid_data) {
          System.out.println("read: " + mh.value.text);
        }
      } else if (status == RETCODE_NO_DATA.value) {
        return;
      } else {
        System.err.println("ERROR: take_next_sample_: " + status);
        return;
      }
    }
  }

  public void on_requested_deadline_missed(DDS.DataReader reader, RequestedDeadlineMissedStatus status) {
  }

  public void on_requested_incompatible_qos(DDS.DataReader reader, RequestedIncompatibleQosStatus status) {
  }

  public void on_sample_rejected(DDS.DataReader reader, SampleRejectedStatus status) {
  }

  public void on_liveliness_changed(DDS.DataReader reader, LivelinessChangedStatus status) {
  }

  public void on_subscription_matched(DDS.DataReader reader, SubscriptionMatchedStatus status) {
  }

  public void on_sample_lost(DDS.DataReader reader, SampleLostStatus status) {
  }
}
