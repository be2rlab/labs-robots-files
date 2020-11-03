#!/usr/bin/python
import rospy, string, threading, time, numpy as np
from numpy import sin, cos, pi

from sensor_msgs.msg import JointState
from brics_actuator.msg import JointPositions, JointValue, JointVelocities, JointTorques


class Measuring:

    def __init__(self):
        self.lock = threading.Lock()

        self.js_sub = rospy.Subscriber("joint_states", JointState, self.js_callback)
        self.jp_pub = rospy.Publisher("arm_1/arm_controller/position_command", JointPositions, queue_size=2, latch=True)
        self.jv_pub = rospy.Publisher("arm_1/arm_controller/velocity_command", JointVelocities, queue_size=2,
                                      latch=True)
        self.jt_pub = rospy.Publisher("arm_1/arm_controller/torques_command", JointTorques, queue_size=2, latch=True)

        T = 25
        self.nf = 5
        self.w0 = 2 * np.pi / T

        self.theta = np.matrix([
            [5.793967012375577, 2.581259883309473, -5.848550947031585, 3.289749008309455, 5.192705575195015],
            [0.321943911368054, -0.326233197980345, -0.153091575724563, 1.863400415940263, -1.665798046872587],
            [-1.133035129520956, 0.985463775157897, -1.948480537140734, -0.034520488891306, -0.686791259080594],
            [1.091778061682040, -0.231489691332760, 0.333249868259229, 0.110760243377397, -0.099764716068035],
            [-0.113664405573988, -0.310611304169263, 0.444374893380780, -0.001324148970973, 0.274698038028977],
            [-0.010542782368367, -0.056260966218253, 0.166728962336444, -0.430627640552204, -0.000091178336994],
            [-0.028691207368119, 0.042984816330886, -0.116819093591486, 0.009122307002503, 0.225647022322327],
            [-0.029181055299833, -0.148204300635701, 0.112560089194585, -0.030392168934422, 0.075504848354089],
            [0.030669798158624, 0.004797892394422, -0.087119024602833, 0.012358086026998, -0.104809111456099],
            [0.022233057458456, 0.007359641050307, 0.057742460796260, 0.090261975553105, 0.034306328705916],
            [0.035636579370007, -0.079112707726557, 0.030625462336029, 0.042038055479805, 0.022988354878708]
        ])

        # self.pose_state = np.matrix([0,0,0,0,0])
        # self.vels_state = np.matrix([0,0,0,0,0])

        self.pose_state = [0, 0, 0, 0, 0]
        self.vels_state = [0, 0, 0, 0, 0]
        self.torq_state = [0, 0, 0, 0, 0]

        self.log = open('vels.txt', 'w')

    def __del__(self):
        self.log.close()

    def js_callback(self, js_msg):
        self.lock.acquire()
        self.pose_state = js_msg.position
        self.vels_state = js_msg.velocity
        self.torq_state = js_msg.effort
        self.lock.release()

    def get_qi(self, ti):
        w0 = self.w0
        m = 2 * self.nf + 1;

        omega = np.zeros((3, m));
        omega[0, 0] = 0.5;
        for k in range(1, m):
            kp = k + 1
            if k % 2 != 0:
                omega[0, k] = cos(kp * w0 * ti);
                omega[1, k] = -kp * w0 * sin(kp * w0 * ti);
                omega[2, k] = -(kp * w0) * (kp * w0) * cos(kp * w0 * ti);
            else:
                omega[0, k] = sin(kp * w0 * ti);
                omega[1, k] = kp * w0 * cos(kp * w0 * ti);
                omega[2, k] = -(kp * w0) * (kp * w0) * sin(kp * w0 * ti);

        Q = omega * self.theta;
        return Q

    def loop(self):
        rate = rospy.Rate(300)
        start_time = time.time()
        while not rospy.is_shutdown():
            ti = time.time() - start_time
            ti = ti * 1

            if ti > 17.8:
                print('more')
                ti = ti + 1.65

            Q = self.get_qi(ti)
            print(ti)

            # # position = [3.73, 2.00, -2.62, 2.14, 2.70]
            # Q = np.matrix([3.6, 1.18, -2.63, 1.75, 2.89])
            # dQ = np.matrix([0, 0, 0, 0, 0])
            # # e = 25 * (Q - self.pose_state)
            # # de = 20 * (dQ - self.vels_state)
            # tau = e + de
            # jt_msg = JointTorques()
            # for i in range(5):
            #
            #     if tau[0,i] > 8:
            #         tau[0,i] = 8
            #     elif tau[0,i] < -8:
            #         tau[0,i] = -8
            #
            #     jt_msg.torques.append(JointValue())
            #     jt_msg.torques[i].joint_uri = 'arm_joint_' + str(i + 1)
            #     jt_msg.torques[i].unit = b"m^2 kg s^-2 rad^-1"
            #     jt_msg.torques[i].value = tau[0,i]
            # self.jt_pub.publish(jt_msg)

            # e = np.ones((5,5)) * np.matrix([6,0,0,0,0]).transpose() * (Q[0, :] - np.matrix(self.pose_state))
            # de = np.ones((5, 5)) * np.matrix([6, 0, 0, 0, 0]).transpose() * (Q[1, :] - np.matrix(self.vels_state))
            # u = e + de

            jp_msg = JointPositions()
            for j in range(5):
                jp_msg.positions.append(JointValue())
                jp_msg.positions[j].joint_uri = 'arm_joint_' + str(j + 1)
                jp_msg.positions[j].unit = b'rad'
                jp_msg.positions[j].value = Q[0, j]
            # jp_msg.positions[0].value = Q[0, 0]
            self.jp_pub.publish(jp_msg)

            s = "{} {} {} {} {} ".format(self.pose_state[0], self.pose_state[1], self.pose_state[2], self.pose_state[3],self.pose_state[4])
            s = s + "{} {} {} {} {} ".format(self.vels_state[0], self.vels_state[1], self.vels_state[2], self.vels_state[3], self.vels_state[4])
            s = s + "{} {} {} {} {} ".format(self.torq_state[0], self.torq_state[1], self.torq_state[2], self.torq_state[3], self.torq_state[4])
            s = s + "{} {} {} {} {} ".format(Q[0, 0], Q[0, 1], Q[0, 2], Q[0, 3], Q[0, 4])
            s = s + "{} {} {} {} {} ".format(Q[1, 0], Q[1, 1], Q[1, 2], Q[1, 3], Q[1, 4])
            s = s + "{} {} {} {} {} ".format(Q[2, 0], Q[2, 1], Q[2, 2], Q[2, 3], Q[2, 4])
            s = s + "{}\n".format(ti)
            self.log.write(s)

            # s = "{} {} {} {} {} ".format(self.vels_state[0],self.vels_state[1],self.vels_state[2],self.vels_state[3],self.vels_state[4])
            # s = s + "{} {} {} {} {} ".format(self.pose_state[0], self.pose_state[1], self.pose_state[2], self.pose_state[3],self.pose_state[4])
            # s = s + "{} {} {} {} {} ".format(Q[1, 0], Q[1, 1], Q[1, 2], Q[1, 3], Q[1, 4])
            # s = s + "{} {} {} {} {} ".format(Q[0, 0], Q[0, 1], Q[0, 2], Q[0, 3], Q[0, 4])
            # s = s + "{}\n".format(ti)
            # self.log.write(s)

            # u = 0.1 * (Q[1, :] - self.vels_state)
            # jv_msg = JointVelocities()
            # for i in range(5):
            #     jv_msg.velocities.append(JointValue())
            #     jv_msg.velocities[i].joint_uri = 'arm_joint_' + str(i + 1)
            #     jv_msg.velocities[i].unit = 's^-1 rad'
            #     jv_msg.velocities[i].value = Q[1, i]
            # self.jv_pub.publish(jv_msg)

            rate.sleep()


if __name__ == "__main__":
    rospy.init_node("measuring")
    m = Measuring()
    m.loop()
