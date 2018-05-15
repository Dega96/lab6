LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity Digital_Filter is 
	port (
				clk, start, rst	: in std_logic;
				Data_IN				: in signed( 7 downto 0);
				M 						: out signed( 7 downto 0);
				Data_out_mem_B		: out signed (7 downto 0)
			);
end Digital_Filter;

architecture behav of Digital_filter is

--dichiarazione degli stati
	TYPE State_type is (IDLE, WRITE_IN_A, AB, MINUS_D_WR_B, MINUS_D, PLUS_Y, MINUS_Y, LOWER_SAT, GREATER_SAT, EQUAL_SAT, AVERAGE);
	Signal stato	:State_type;
--dichiarazione dei segnali per gli stati
	signal TC1, TC2 : std_logic; --il primo serve per uscire dallo stato di scrittura in A...il secondo per fare la media
	

-- dichiarazione dei segnali per il contatore
	signal cnt_en	: std_logic;
	signal cnt	: unsigned(11 downto 0);

-- dichiarazione dei segnali per la Mem_A
	signal data_out_Mem_A, data_in_Mem_A : signed (7 downto 0);
	signal CS_A									 : std_logic;
	signal wr_n_rd_A							 : std_logic;
	
-- dichiarazione dei segnali per la Mem_B
	signal y_mem_B								 : signed (7 downto 0);
	signal CS_B									 : std_logic;
	signal wr_n_rd_B							 : std_logic;
	
-- dichiarazione seganli per le operazioni
	signal data_A_8_bit, data_B_8_bit, data_C_8_bit, data_D_8_bit: signed (7 downto 0);
	signal data_A_10_bit, data_B_10_bit, data_D_10_bit: signed (9 downto 0);

-- dichiarazione dei segnali di ENABLE dei registri
	signal LD_R_1, EN_y_1 			: std_logic;

	
-- dichiarazione dei segnali che escono dai mux e per selezionare il dato che deve uscire
	signal data_mux_1, data_mux_2	: signed (9 downto 0);
	signal data_mux_3					: signed (7 downto 0);
	signal Sel_2	: std_logic_vector (1 downto 0); --sel del mux3
	signal Sel_1	: std_logic_vector (1 downto 0); --sel del mux1 e mux2
	
-- dichiarazione del segnale per decidere se sommare o sottrare tramite il sommatore_1
	signal Add_n_Sub	: std_logic;
	
-- dichiarazione dei segnali in ingresso e in uscita dal registro Reg_Y
	signal y_prima	  : signed (9 downto 0);
	signal y_dopo	  : signed (9 downto 0);
	
-- dichiarazione segnali per il controllo della saturazione di y e del dato in uscita dal saturatore
	signal a,b	: std_logic;
	signal y_sat	: signed (7 downto 0);
	
-- dichiarazione dei segnali usati per la media...in ingresso al sommatore usiamo data_out
	signal Data_sum_in, Data_sum_out, Data_out_mem_A_18_bit : signed (17 downto 0);   --l'ultimo serve per portare da 8 a 18 il parallelismo del dato letto dalla mem_A
	signal Data_media_in, Data_media_out					: signed (7 downto 0);

-- dichiarazione del segnale di DONE
	signal DONE	: std_logic;
	
	
	--memoria RAM
	component SRAM_SW_AR_1024x8_DEC is
		port( 
				ADDRESS : in std_logic_vector (9 downto 0);
				DATA_IN : in signed(7 downto 0);
				DATA_OUT: out signed(7 downto 0);
				CS, WR, RD, CLK : in std_logic
			  );
		end component;
		
		--Registro con parallelismo da 8 bit utilizzato per Reg_A Reg_B Reg_C Reg_D Reg_MEDIA
	component Reg_8_bit is
	generic (n : integer := 8);
	port ( D : in signed(n-1 downto 0);
			 Rest, Clock, EN : in std_logic;
			 Q : out signed(N-1 downto 0)
			 );
	end component;


--Registro con parallelismo da 10 bit utilizzato per Reg_y
	component Reg_10_bit is
	generic (n : integer := 10);
	port ( D : in signed(n-1 downto 0);
			 Rest, Clock, EN : in std_logic;
			 Q : out signed(N-1 downto 0)
			 );
	end component;


--Registro con parallelismo da 18 bit utilizzato per Reg_Sum
	component Reg_18_bit is
	generic (n : integer := 18);
	port ( D : in signed(n-1 downto 0);
			 Rest, Clock, EN : in std_logic;
			 Q : out signed(N-1 downto 0)
			 );
	end component;

	--contatore
	component counter_12_bit_sincrono is
		generic ( N : integer:=12);
		port 
			(
			Cnt_EN, CLK, Clear: in std_logic; 
		 Q: buffer unsigned(N-1 downto 0)
			);
	end component;
	
	--componente decoder
	component Decoder is
	port(
			EN					: in std_logic;
			D					: out std_logic_vector( 3 downto 0);
			sel				: in std_logic_vector( 1 downto 0)
		 );
	end component;
	
	--componente mux per il saturatore
	component mux_4_to_1_8bit is
	port(
			sel	: in std_logic_vector (1 downto 0);
			y1, y2, y3, y4		: in signed (7 downto 0);
			y_sat	: out signed (7 downto 0)
		);
	end component;
	
	--componente mux per il sommatore
	component mux_4_to_1_10bit is
	port(
			sel	: in std_logic_vector (1 downto 0);
			Data_00		: in signed (9 downto 0);
			Data_01		: in signed(9 downto 0);
			Data_10_11	: in signed (9 downto 0);
			y				: out signed (9 downto 0)
		);
	end component;

	--Sommatore con parallelismo da 10 bit utilizzato per i calcoli per valutare il dato inserire nella Mem_B
	component Adder_Subtractor_10_bit is
	generic (n : integer := 10);
		port(
				c_in : IN std_logic;
				a, b : IN signed (n-1 downto 0);
				y	  : Out signed (n-1 downto 0)
			 );
	end component;
	
	--Sommatore con parallelismo da 18 bit utilizzato per il calcolo della media dei dati della Mem_A
	component Adder_Subtractor_18_bit is
	generic (n : integer := 18);
		port(
				c_in : IN std_logic;
				a, b : IN signed (n-1 downto 0);
				y	  : Out signed (n-1 downto 0)
			 );
	end component;
	
	
	
	
	begin
	
	FSM_transitions: Process(Rst,  clk)
	begin
		If Rst = '1' then
			stato<= IDLE;
		elsif(clk' event And clk='1') then
			CASE stato is
				WHEN IDLLE        => If start = '0' then stato <= IDLE; else stato <= WRITE_IN_A; end if;
				WHEN WRITE_IN_A   => if TC1 = '0' then stato <= WRITE_IN_A; else stato <= AB; end if;
				WHEN AB
				WHEN MINUS_D_WR_B 
				WHEN MINUS_D
				WHEN PLUS_Y
				WHEN MINUS_Y
				WHEN LOWER_SAT
				WHEN GREATER_SAT
				WHEN EQUAL_SAT
				WHEN AVERAGE
	
	
	
	--Descrizione del Data Path
	
	-- descrizione del contatore
	contatore: counter_12_bit_sincrono port map( Cnt_En => cnt_en, clk => clk, clear => rst, Q => cnt);
	
	-- Descrizione della Mem_A
	data_in_Mem_A <= Data_IN;
	Mem_A: SRAM_SW_AR_1024x8_DEC port map (Address => std_logic_vector(cnt(11 downto 2)), Data_in => data_in_Mem_A, data_out => data_out_mem_A, CS => CS_A, WR => wr_n_rd_A, RD => wr_n_rd_A, clk => clk);
	
	--caricamento e shift dei registri
	Reg_A: Reg_8_bit port map (D =>data_out_mem_A , Rest => Rst, Clock => clk , Q =>Data_A_8_bit , EN => LD_R_1 );
	Reg_B: Reg_8_bit port map (D =>data_A_8_bit , Rest =>Rst, Clock =>clk , Q => Data_B_8_bit , EN => LD_R_1);
	Reg_C: Reg_8_bit port map (D =>data_B_8_bit, Rest => Rst, Clock =>clk, Q => Data_C_8_bit, EN =>LD_R_1);
	Reg_D: Reg_8_bit port map (D =>data_C_8_bit, Rest =>Rst, Clock => clk, Q => Data_D_8_bit, EN => LD_R_1);
	
	--operazione di A/4
	Data_A_10_bit <= (Data_A_8_bit(7) & Data_A_8_bit(7) & Data_A_8_bit(7) & Data_A_8_bit(7) & Data_A_8_bit(7 downto 2));
	--incremento del parallelismo del dato_B da 8 a 10 bit
	Data_B_10_bit <= (Data_B_8_bit(7) & Data_B_8_bit(7) & Data_B_8_bit(7 downto 0));
	--operazione di D*2
	Data_D_10_bit <= ( Data_D_10_bit(7) & Data_D_10_bit(7 downto 0) & '0');
	
	--descrizione del mux1
	mux1: mux_4_to_1_10bit port map (Data_00 => Data_A_10_bit, Data_01 => y_dopo, Data_10_11 => "0000000000", sel => sel_1, y => data_mux_1);
	mux2: mux_4_to_1_10bit port map (Data_00 => data_b_10_bit, Data_01 => Data_D_10_bit, Data_10_11 => y_dopo, sel => sel_1, y => data_mux_2);
	
	--descrizione del sommatore per fare i calcoli per y
	Sommatore_1: Adder_Subtractor_10_bit port map(a => data_mux_1, b => data_mux_2, y => y_prima, c_in => Add_n_Sub);
	
	--descrizione del registro Reg_Y
	Reg_Y: Reg_10_bit port map (D => y_prima, rest => rst, clock => clk, Q => y_dopo, EN => EN_y_1);
	
	--descrizione del saturatore:  logica per settare i valori di A e B e mux... A e B settano Sel2
	A <= y_dopo(9) and not( y_dopo(8) and y_dopo(7));
	B <=  not(y_dopo(9)) and ( y_dopo(8) or y_dopo(7));
	mux_3: mux_4_to_1_8bit port map( sel => sel_2, y1 => y_dopo(7 downto 0), y2 => "01111111", y3 => "10000000", y4 => y_dopo( 7 downto 0), y_sat => y_sat);
	
	--descrizione della Mem_B
	Mem_B: SRAM_SW_AR_1024x8_DEC port map (Address => std_logic_vector(cnt(11 downto 2)), Data_in => y_sat, data_out => y_mem_B, CS => CS_B, WR => wr_n_rd_B, RD => wr_n_rd_B, clk => clk);
	Data_out_mem_B <= y_mem_B;
	
	--descrizione della struttura che calcola la media
	--aumento del parallelismo del dato letto della memoria A
	Data_out_mem_A_18_bit <= (data_out_mem_A(7) & data_out_mem_A(7) & data_out_mem_A(7) & data_out_mem_A(7)
										& data_out_mem_A(7) & data_out_mem_A(7) & data_out_mem_A(7) & data_out_mem_A(7)
										& data_out_mem_A(7) & data_out_mem_A(7) & data_out_mem_A(7 downto 0));
	--sommo il valore di reg_sum con il valore letto da mem_A
	Sommatore_2: Adder_subtractor_18_bit port map (a => data_sum_in, b => Data_out_mem_A_18_bit, c_in => '0', y => data_sum_out);
	Reg_Sum	  : Reg_18_bit port map( D => data_sum_out, Rest => Rst, Clock => clk, Q => data_sum_in, EN => LD_R_1);
	Data_Media_IN <= data_sum_in(17 downto 10);
	Reg_M 	  : Reg_8_bit port map( D => Data_Media_in, Rest => Rst, Clock => clk, Q => Data_media_out, EN => DONE);
	--associazione del dato di media alla porta di uscita
	M <= Data_media_out;
	
end behav;