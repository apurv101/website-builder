import './App.css'

function App() {
  return (
    <div className="page">
      <nav className="nav">
        <div className="nav-inner">
          <a href="/" className="logo">Zevza</a>
        </div>
      </nav>

      <header className="hero">
        <h1>Build a website by chatting with AI</h1>
        <p className="subtitle">
          Tell Zev what you want. Get a professional, modern website — deployed instantly.
        </p>
        <a href="https://zevza.com" className="cta-button">
          Start Building — Free
        </a>
      </header>

      <section className="features" id="features">
        <h2>How it works</h2>
        <div className="features-grid">
          <div className="feature-card">
            <div className="feature-icon">💬</div>
            <h3>Chat with Zev</h3>
            <p>Describe the website you want in plain English. No design skills or coding knowledge needed.</p>
          </div>
          <div className="feature-card">
            <div className="feature-icon">⚡</div>
            <h3>AI builds it live</h3>
            <p>Zev generates a modern site using React + TypeScript. Watch it come together in real time.</p>
          </div>
          <div className="feature-card">
            <div className="feature-icon">🚀</div>
            <h3>Deploy instantly</h3>
            <p>Your site goes live at <code>yourname.zevza.com</code> — no setup, no hosting to configure.</p>
          </div>
        </div>
      </section>

      <section className="use-cases">
        <h2>What can you build?</h2>
        <div className="use-cases-grid">
          {[
            'Portfolio sites',
            'Startup landing pages',
            'Small business websites',
            'Event & wedding pages',
            'Developer blogs',
            'Project showcases',
          ].map((item) => (
            <div key={item} className="use-case-item">{item}</div>
          ))}
        </div>
      </section>

      <section className="cta-section">
        <h2>Ready to build your site?</h2>
        <p>No signup required. Just start chatting.</p>
        <a href="https://zevza.com" className="cta-button">
          Start Building — Free
        </a>
      </section>

      <footer className="footer">
        <p>&copy; {new Date().getFullYear()} Zevza. AI-powered website builder.</p>
      </footer>
    </div>
  )
}

export default App
