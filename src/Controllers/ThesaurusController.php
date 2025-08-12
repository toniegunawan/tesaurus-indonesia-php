<?php

namespace Thesaurus\Controllers;

use Thesaurus\Services\ThesaurusService;
use Thesaurus\Database\Connection;

class ThesaurusController
{
    private ThesaurusService $thesaurusService;

    public function __construct()
    {
        $connection = new Connection();
        $this->thesaurusService = new ThesaurusService($connection);
    }

    /**
     * Handle API requests
     */
    public function handleRequest(): void
    {
        // Set JSON response header
        header('Content-Type: application/json');
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type');

        // Handle preflight requests
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
            http_response_code(200);
            exit;
        }

        $method = $_SERVER['REQUEST_METHOD'];
        $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $query = $_GET;

        try {
            switch ($path) {
                case '/api/search':
                    $this->searchWord($query);
                    break;
                
                case '/api/autocomplete':
                    $this->autocomplete($query);
                    break;
                
                case '/api/words':
                    $this->getAllWords($query);
                    break;
                
                case '/api/stats':
                    $this->getStatistics();
                    break;
                
                default:
                    $this->notFound();
                    break;
            }
        } catch (\Exception $e) {
            $this->errorResponse('Internal server error: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Search for synonyms and antonyms
     */
    private function searchWord(array $query): void
    {
        if (!isset($query['word']) || empty(trim($query['word']))) {
            $this->errorResponse('Parameter "word" is required', 400);
            return;
        }

        $word = trim($query['word']);
        $result = $this->thesaurusService->searchWord($word);

        if (isset($result['error'])) {
            $this->errorResponse($result['error'], 404);
            return;
        }

        $this->successResponse($result);
    }

    /**
     * Autocomplete search
     */
    private function autocomplete(array $query): void
    {
        if (!isset($query['q']) || empty(trim($query['q']))) {
            $this->errorResponse('Parameter "q" is required', 400);
            return;
        }

        $pattern = trim($query['q']);
        $limit = isset($query['limit']) ? (int)$query['limit'] : 10;
        $limit = min(max($limit, 1), 50); // Limit between 1 and 50

        $results = $this->thesaurusService->searchWordsByPattern($pattern, $limit);
        $this->successResponse(['suggestions' => $results]);
    }

    /**
     * Get all words with pagination
     */
    private function getAllWords(array $query): void
    {
        $limit = isset($query['limit']) ? (int)$query['limit'] : 100;
        $offset = isset($query['offset']) ? (int)$query['offset'] : 0;
        
        $limit = min(max($limit, 1), 1000); // Limit between 1 and 1000
        $offset = max($offset, 0);

        $words = $this->thesaurusService->getAllWords($limit, $offset);
        $this->successResponse([
            'words' => $words,
            'pagination' => [
                'limit' => $limit,
                'offset' => $offset,
                'count' => count($words)
            ]
        ]);
    }

    /**
     * Get thesaurus statistics
     */
    private function getStatistics(): void
    {
        $stats = $this->thesaurusService->getStatistics();
        $this->successResponse($stats);
    }

    /**
     * Handle 404 not found
     */
    private function notFound(): void
    {
        $this->errorResponse('Endpoint not found', 404);
    }

    /**
     * Send success response
     */
    private function successResponse(array $data): void
    {
        http_response_code(200);
        echo json_encode([
            'success' => true,
            'data' => $data
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    }

    /**
     * Send error response
     */
    private function errorResponse(string $message, int $code = 400): void
    {
        http_response_code($code);
        echo json_encode([
            'success' => false,
            'error' => $message
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    }
}
