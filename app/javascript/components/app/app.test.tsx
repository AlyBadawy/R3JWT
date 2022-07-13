import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom/extend-expect';
import { App } from './App';

describe('App', () => {
  it('Renders the document with correct paragraph', () => {
    render(<App />);
    const paragraph = screen.getByText(/This is rendered by React/i);
    expect(paragraph).toBeInTheDocument();
  });
});
