// LearnSpace — Login screen
const { useState: useStateLogin } = React;

function LoginScreen({ onLogin }) {
  const [show, setShow] = useStateLogin(false);
  const [email, setEmail] = useStateLogin('quynhanh@email.com');
  const [pw, setPw] = useStateLogin('123456');

  return (
    <div className="screen">
      <div className="screen__scroll">
        <div className="login">
          <div className="login__hero">
            <div className="login__logo">
              <Icon name="route" size={30} stroke="#fff" sw={2} />
            </div>
            <div className="login__brand">LearnSpace</div>
            <div className="login__tag">Học tiếng Anh cùng cộng đồng — theo lộ trình, giữ streak, kết nối gia sư.</div>
          </div>

          <div className="login__form">
            <div className="field">
              <label className="field__label">Email hoặc tên đăng nhập</label>
              <input className="field__input" value={email} onChange={e => setEmail(e.target.value)} placeholder="email@example.com" />
            </div>
            <div className="field">
              <label className="field__label">Mật khẩu</label>
              <div className="field__wrap">
                <input className="field__input" style={{ width: '100%', paddingRight: 44 }} type={show ? 'text' : 'password'} value={pw} onChange={e => setPw(e.target.value)} placeholder="••••••••" />
                <button className="field__eye" onClick={() => setShow(s => !s)} aria-label="hiện mật khẩu"><Icon name="eye" size={18} /></button>
              </div>
            </div>
            <span className="login__forgot">Quên mật khẩu?</span>

            <button className="btn btn--primary btn--block btn--lg" onClick={onLogin} style={{ marginTop: 4 }}>Đăng nhập</button>

            <div className="login__divider">hoặc tiếp tục với</div>
            <div className="social">
              <button className="social__btn" onClick={onLogin}><Icon name="google" size={20} /> Google</button>
              <button className="social__btn" onClick={onLogin}><Icon name="apple" size={20} /> Apple</button>
            </div>
          </div>

          <div className="login__signup">Chưa có tài khoản? <b>Đăng ký ngay</b></div>
        </div>
      </div>
    </div>
  );
}

window.LoginScreen = LoginScreen;
