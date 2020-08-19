import DDS.*;
import OpenDDS.DCPS.*;
import org.omg.CORBA.StringSeqHolder;
import Example.*;

public class ExampleSubscriber {

  public static void main(String[] args) {

    DomainParticipantFactory dpf = TheParticipantFactory.WithArgs(new StringSeqHolder(args));
    if (dpf == null) {
      System.err.println("ERROR: Domain Participant Factory not found");
      return;
    }

    DomainParticipant dp = dpf.create_participant(4, PARTICIPANT_QOS_DEFAULT.get(), null, DEFAULT_STATUS_MASK.value);
    if (dp == null) {
      System.err.println("ERROR: Domain Participant creation failed");
      return;
    }

    MessageTypeSupportImpl ts = new MessageTypeSupportImpl();
    if (ts.register_type(dp, "") != RETCODE_OK.value) {
      System.err.println("ERROR: register_type failed");
      return;
    }

    Topic top = dp.create_topic("Example", ts.get_type_name(), TOPIC_QOS_DEFAULT.get(), null, DEFAULT_STATUS_MASK.value);
    if (top == null) {
      System.err.println("ERROR: Topic creation failed");
      return;
    }

    Subscriber sub = dp.create_subscriber(SUBSCRIBER_QOS_DEFAULT.get(), null, DEFAULT_STATUS_MASK.value);
    if (sub == null) {
      System.err.println("ERROR: Subscriber creation failed");
      return;
    }

    DataReaderQos dr_qos = DATAREADER_QOS_DEFAULT.get();
    DataReaderQosHolder qos_holder = new DataReaderQosHolder(dr_qos);
    sub.get_default_datareader_qos(qos_holder);
    dr_qos = qos_holder.value;
    dr_qos.durability.kind = DurabilityQosPolicyKind.TRANSIENT_LOCAL_DURABILITY_QOS;
    dr_qos.reliability.kind = ReliabilityQosPolicyKind.RELIABLE_RELIABILITY_QOS;

    DataReader dr = sub.create_datareader(top, dr_qos, new ExampleListener(), DEFAULT_STATUS_MASK.value);
    if (dr == null) {
      System.err.println("ERROR: DataReader creation failed");
      return;
    }

    try {
      Thread.sleep(60 * 1000);
    } catch(InterruptedException ie) {
    }

    dp.delete_contained_entities();
    dpf.delete_participant(dp);
    TheServiceParticipant.shutdown();
  }

}
