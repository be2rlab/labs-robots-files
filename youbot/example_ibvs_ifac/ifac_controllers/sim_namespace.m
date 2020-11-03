classdef sim_namespace
    
    properties (Access=public)
        q;
        dq;
        q_d;
        dq_d;
        q_e;
        dq_e;
        
        tau_q=0;
        tau_dq=0;
        tau;
        
        p;
        p_d;
        p_e;
        v_c;
        
        lambda;
        norm_e;
        contin_lambda=0;
        v_e;
        
        condM;
        condJi;
        condJe;
    end
    
    methods (Access=public)
        
        function this = sim_namespace(namespace) 
            s = load(namespace);
            
            this.q = s.q;
            this.dq = s.dq;
            this.q_d = s.q_d;
            this.dq_d = s.dq_d;
            this.q_e = s.q_e;
            this.dq_e = s.dq_e;

%             this.tau_q = s.tau_q;
%             this.tau_dq = s.tau_dq;
            this.tau = s.tau;

            this.p = s.p;
            this.p_d = s.p_d;
            this.p_e = s.p_e;
            this.v_c = s.v_c;

            this.lambda = s.lambda;
            this.norm_e = s.norm_e;
%             this.contin_lambda = s.contin_lambda;
            this.v_e = s.v_e;

%             this.condM = s.condM;
            this.condJi = s.condJi;
            this.condJe = s.condJe;            
        end
        
    end
end

