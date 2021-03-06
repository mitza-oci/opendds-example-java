import DDS.*;
import OpenDDS.DCPS.*;
import org.omg.CORBA.StringSeqHolder;
import Example.*;

public class ExamplePublisher {

  public static void main(String[] args) {

    if (args.length < 1) {
      System.err.println("ERROR: provide the message text as a command line argument");
      return;
    }

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

    Publisher pub = dp.create_publisher(PUBLISHER_QOS_DEFAULT.get(), null, DEFAULT_STATUS_MASK.value);
    if (pub == null) {
      System.err.println("ERROR: Publisher creation failed");
      return;
    }

    DataWriterQos dw_qos = DATAWRITER_QOS_DEFAULT.get();
    DataWriterQosHolder qos_holder = new DataWriterQosHolder(dw_qos);
    pub.get_default_datawriter_qos(qos_holder);
    dw_qos = qos_holder.value;
    dw_qos.durability.kind = DurabilityQosPolicyKind.TRANSIENT_LOCAL_DURABILITY_QOS;

    DataWriter dw = pub.create_datawriter(top, dw_qos, null, DEFAULT_STATUS_MASK.value);
    if (dw == null) {
      System.err.println("ERROR: DataWriter creation failed");
      return;
    }

    MessageDataWriter mdw = MessageDataWriterHelper.narrow(dw);
    Message msg = new Message(args[0]);
    int ret = mdw.write(msg, HANDLE_NIL.value);
    if (ret != RETCODE_OK.value) {
      System.err.println("ERROR write() returned " + ret);
    }
    System.out.println("wrote: " + msg.text);

    try {
      Thread.sleep(5 * 1000);
    } catch(InterruptedException ie) {
    }

    dp.delete_contained_entities();
    dpf.delete_participant(dp);
    TheServiceParticipant.shutdown();
  }

}
