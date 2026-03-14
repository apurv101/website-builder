import { Component, type ErrorInfo, type ReactNode } from 'react'

interface Props {
  children: ReactNode
}

interface State {
  hasError: boolean
  error: Error | null
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error('ErrorBoundary caught:', error, info.componentStack)
  }

  render() {
    if (!this.state.hasError) {
      return this.props.children
    }

    const isDev = import.meta.env.DEV

    return (
      <div style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontFamily: 'system-ui, -apple-system, sans-serif',
        padding: '2rem',
        backgroundColor: '#fafafa',
        color: '#333',
      }}>
        <div style={{ textAlign: 'center', maxWidth: '500px' }}>
          <h1 style={{ fontSize: '1.5rem', marginBottom: '0.5rem' }}>
            Something went wrong
          </h1>
          <p style={{ color: '#666', marginBottom: '1.5rem' }}>
            An unexpected error occurred. Please try refreshing the page.
          </p>
          <button
            onClick={() => window.location.reload()}
            style={{
              padding: '0.6rem 1.5rem',
              fontSize: '1rem',
              border: 'none',
              borderRadius: '6px',
              backgroundColor: '#333',
              color: '#fff',
              cursor: 'pointer',
            }}
          >
            Refresh page
          </button>
          {isDev && this.state.error && (
            <pre style={{
              marginTop: '2rem',
              padding: '1rem',
              backgroundColor: '#fee',
              borderRadius: '6px',
              fontSize: '0.8rem',
              textAlign: 'left',
              overflow: 'auto',
              maxHeight: '300px',
              color: '#c00',
            }}>
              {this.state.error.message}
              {'\n\n'}
              {this.state.error.stack}
            </pre>
          )}
        </div>
      </div>
    )
  }
}

export default ErrorBoundary
